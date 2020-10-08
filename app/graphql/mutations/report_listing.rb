class Mutations::ReportListing < Mutations::BaseMutation
  argument :listing_id, Integer, required: true
  argument :text, String, required: true

  def resolve(listing_id:, text:)
    report = ReportedListingService.new(listing_id).report(current_user, text)

    raise_errors(report)

    { message: 'Thanks for reporting! Our team will review immediately.' }
  end
end
