class Mutations::Admin::AcceptListingReports < Mutations::BaseMutation
  argument :listing_id, Integer, required: true

  field :listing, Types::Listing, null: false

  def resolve(listing_id:)
    require_admin!

    listing = Listing.find(listing_id)
    listing.listing_reports.update_all(reviewed_at: Time.current)

    { listing: listing, message: 'Reports marked as reviewed' }
  end
end
