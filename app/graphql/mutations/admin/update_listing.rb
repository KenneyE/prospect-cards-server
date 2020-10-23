class Mutations::Admin::UpdateListing < Mutations::BaseMutation
  argument :listing, Inputs::Admin::ListingInput, required: true

  field :listing, Types::Listing, null: false

  def resolve(listing:)
    require_admin!
    l = Listing.find(listing[:id])
    l.update(listing.to_h)

    raise_errors(l)

    { listing: l, message: 'Listing updated' }
  end
end
