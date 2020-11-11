class Mutations::ToggleFavorite < Mutations::BaseMutation
  argument :listing_id, Integer, required: true
  argument :is_favorited, Boolean, required: true

  field :listing, Types::Listing, null: false

  def resolve(listing_id:, is_favorited:)
    listing = Listing.find(listing_id)
    if is_favorited
      current_user.favorite(listing)
    else
      current_user.unfavorite(listing)
    end

    { listing: listing }
  end
end
