class Mutations::AcceptOffer < Mutations::BaseMutation
  argument :offer_id, Integer, required: true

  def resolve(offer_id:)
    offer = current_user.incoming_offers.find(offer_id)

    offer = AcceptOfferService.new(offer).accept

    raise_errors(offer)

    OffersMailer.with(subscriber_id: offer.user_id).offer_accepted(offer.id)
      .deliver_later

    { message: 'Offer accepted. Congrats!' }
  end
end
