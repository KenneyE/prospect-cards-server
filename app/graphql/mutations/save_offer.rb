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

    payment_intent = _create_intent(offer)
    new_offer = _create_offer(offer, payment_intent)

    raise_errors(new_offer)

    _notify_seller(new_offer)

    { payment_intent_id: payment_intent.client_secret, offer_id: new_offer.id }
  end

  private

  def _create_intent(offer)
    listing = Listing.find(offer[:listing_id])
    price = (offer[:price] * 100).floor
    payment_intent =
      Stripe::PaymentIntent.create(_payment_intent_opts(listing, price))
    StripePaymentIntent.sync(payment_intent)

    payment_intent
  end

  def _create_offer(offer, payment_intent)
    current_user.offers.create(
      price: offer[:price] * 100,
      listing_id: offer[:listing_id],
      payment_intent_id: payment_intent.id,
    )
  end

  def _notify_seller(new_offer)
    ListingsMailer.with(subscriber_id: current_user.id).offer_received(
      new_offer.id,
    ).deliver_later
  end

  def _payment_intent_opts(listing, price)
    {
      customer: current_user.stripe_customer_id,
      payment_method: current_user.stripe_payment_methods.first.token,
      amount: price,
      currency: 'usd',
      capture_method: 'manual',
      application_fee_amount: (price * 0.05).to_i,
      transfer_data: { destination: listing.user.stripe_account_id },
    }
  end
end
