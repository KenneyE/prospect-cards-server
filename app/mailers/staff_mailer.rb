class StaffMailer < ApplicationMailer
  def reported_listing(report_id)
    @report = ListingReport.find(report_id)
    mail(
      to: 'e.kenney@prospect.cards',
      subject: '[ACTION REQUIRED] Listing Reported',
    )
  end
end
