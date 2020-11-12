class Mutations::SaveOffer < Mutations::BaseMutation
  argument :offer, Inputs::OfferInput, required: true

  # Return null if unable to create intent
  field :payment_intent_id, String, null: true
  field :offer_id, Integer, null: true
  def resolve(offer:)
    require_confirmation!

    unless current_user.payment_method?
      return { payment_intent_id: nil, offer_id: nil }
    end

    @listing = Listing.find(offer[:listing_id])
    @offer_input = offer

    payment_intent = _create_intent
    new_offer = _create_offer(payment_intent)

    raise_errors(new_offer)

    if _buy_now?
      offer = AcceptOfferService.new(new_offer).accept
      _notify_seller_of_buy_now(new_offer) if offer.valid?
    else
      _notify_seller_of_offer(new_offer)
    end


    { payment_intent_id: payment_intent.client_secret, offer_id: new_offer.id }
  end

  private

  def _buy_now?
    _offer_price == @listing.price
  end

  def _create_intent
    payment_intent =
      Stripe::PaymentIntent.create(_payment_intent_opts)
    StripePaymentIntent.sync(payment_intent)

    payment_intent
  end

  def _create_offer(payment_intent)
    current_user.offers.create(
      price: _offer_price,
      listing_id: @listing.id,
      payment_intent_id: payment_intent.id,
    )
  end

  def _notify_seller_of_buy_now(new_offer)
    new_offer.seller.notices.create(
      title: "You Sold #{new_offer.listing.title}!",
      text: "Your listing was purchased for  #{new_offer.formatted_price}",
      path: "/listings/#{new_offer.listing_id}",
    )
    ListingsMailer.with(subscriber_id: new_offer.seller).offer_received(
      new_offer.id,
      ).deliver_later
  end


  def _notify_seller_of_offer(new_offer)
    new_offer.seller.notices.create(
      title: "New Offer for #{new_offer.listing.title}!",
      text: "Someone offered #{new_offer.formatted_price} for your listing",
      path: "/listings/#{new_offer.listing_id}",
    )
    ListingsMailer.with(subscriber_id: new_offer.seller).offer_received(
      new_offer.id,
    ).deliver_later
  end

  def _payment_intent_opts
    {
      customer: current_user.stripe_customer_id,
      payment_method: current_user.payment_method.token,
      amount: _offer_price,
      currency: 'usd',
      capture_method: 'manual',
      application_fee_amount: (_offer_price * 0.05).to_i,
      transfer_data: { destination: @listing.user.stripe_account_id },
    }
  end

  def _offer_price
    (@offer_input[:price] * 100).floor
  end
end
