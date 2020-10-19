class Mutations::AcceptOffer < Mutations::BaseMutation
  argument :offer_id, Integer, required: true

  def resolve(offer_id:)
    offer = current_user.incoming_offers.find(offer_id)

    offer = AcceptOfferService.new(offer).accept

    raise_errors(offer)

    { message: 'Offer accepted. Congrats!' }
  end
end
