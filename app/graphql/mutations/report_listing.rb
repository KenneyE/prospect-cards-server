class Mutations::ReportListing < Mutations::BaseMutation
  argument :listing_id, Integer, required: true
  argument :text, String, required: true

  def resolve(listing_id:, text:)
    listing = Listing.find(listing_id)
    report = ReportedListingService.new(listing).report(current_user, text)

    raise_errors(report)

    { message: 'Thanks for reporting! Our team will review immediately.' }
  end
end
