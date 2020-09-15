# typed: true
class Mutations::TrackInterest < Mutations::BaseMutation
  argument :listing_id, Integer, required: true

  field :success, Boolean, null: false

  def resolve(listing_id:)
    current_user.players << Listing.find(listing_id).player if current_user.present?

    { success: true }
  end
end
