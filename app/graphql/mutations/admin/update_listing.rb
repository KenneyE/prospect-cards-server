class Mutations::Admin::UpdateListing < Mutations::BaseMutation
  argument :listing_id, Integer, required: true
  argument :listing, Inputs::ListingInput, required: true

  field :listing, Types::Listing, null: false

  def resolve(listing_id:, listing:)
    require_admin!
    l = Listing.find(listing_id)
    l.update(listing.to_h)

    raise_errors(l)

    { listing: listing, message: 'Listing updated' }
  end
end
