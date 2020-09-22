class Mutations::SaveOffer < Mutations::BaseMutation
  argument :offer, Inputs::OfferInput, required: true

  field :viewer, Types::User, null: false
  def resolve(offer:)
    new_offer = current_user.offers.create(
      price: offer[:price] * 100,
      listing_id: offer[:listing_id],
    )

    raise_errors(new_offer)

    { viewer: current_user, message: 'Offer submitted!' }
  end
end