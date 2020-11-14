class StaffMailer < ApplicationMailer
  def reported_listing(report_id)
    @report = ListingReport.find(report_id)
    mail(
      to: 'e.kenney@prospect.cards,ekenney5@gmail.com',
      subject: '[ACTION REQUIRED] Listing Reported',
    )
  end
end
