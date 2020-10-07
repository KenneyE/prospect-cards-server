class Mutations::TempConfirmOffer < Mutations::BaseMutation
  argument :offer_id, Integer, required: true

  # Return null if unable to create intent
  field :viewer, Types::User, null: true
  def resolve(offer_id:)
    offer = current_user.offers.find(offer_id)
    offer.update(temp_confirmed: true)

    raise_errors(offer)

    { viewer: current_user.reload }
  end
end
