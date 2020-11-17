class Mutations::ConfirmOffer < Mutations::BaseMutation
  argument :offer_id, Integer, required: true

  # Return null if unable to create intent
  field :viewer, Types::User, null: true
  def resolve(offer_id:)
    offer = current_user.offers.find(offer_id)
    offer.update(confirmed: true)

    raise_errors(offer)

    if _buy_now?(offer)
      offer = AcceptOfferService.new(offer).accept
      raise_errors(offer)

      _notify_seller_of_buy_now(offer)
      _notify_buyer(offer)
    else
      _notify_seller_of_offer(offer)
    end

    { viewer: current_user.reload }
  end

  private

  def _buy_now?(offer)
    offer.price == offer.listing.price
  end

  def _notify_seller_of_buy_now(new_offer)
    new_offer.seller.notices.create(
      title: "You Sold #{new_offer.listing.title}!",
      text: "Your listing was purchased for  #{new_offer.formatted_price}",
      path: "/listings/#{new_offer.listing_id}",
    )
    ListingsMailer.with(subscriber_id: new_offer.seller.id).buy_now(new_offer.id)
      .deliver_later
  end

  def _notify_buyer(offer)
    OffersMailer.with(subscriber_id: offer.user_id).buy_now_confirmation(
      offer.id,
      ).deliver_later
  end

  def _notify_seller_of_offer(offer)
    offer.seller.notices.create(
      title: "New Offer for #{offer.listing.title}!",
      text: "Someone offered #{offer.formatted_price} for your listing",
      path: "/listings/#{offer.listing_id}",
      )
    ListingsMailer.with(subscriber_id: offer.seller.id).offer_received(
      offer.id,
      ).deliver_later
  end

end
