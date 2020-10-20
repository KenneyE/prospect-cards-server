class Mutations::ReportListing < Mutations::BaseMutation
  argument :listing_id, Integer, required: true
  argument :text, String, required: true

  def resolve(listing_id:, text:)
    require_confirmation!

    report = ReportedListingService.new(listing_id).report(current_user, text)

    raise_errors(report)

    _notify_staff(report)

    { message: 'Thanks for reporting! Our team will review immediately.' }
  end

  private

  def _notify_staff(report)
    StaffMailer.reported_listing(report.id).deliver_later
  end
end
