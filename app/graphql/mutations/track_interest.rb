class Mutations::TrackInterest < Mutations::BaseMutation
  argument :listing_id, Integer, required: true

  field :success, Boolean, null: false

  def resolve(listing_id:)
    if current_user.present?
      current_user.players << Listing.find(listing_id).player
    end

    { success: true }
  end
end
