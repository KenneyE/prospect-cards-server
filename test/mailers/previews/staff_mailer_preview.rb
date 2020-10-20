# Preview all emails at http://localhost:3000/rails/mailers/staff_mailer
class StaffMailerPreview < ActionMailer::Preview
  def reported_listing
    report = ListingReport.first
    StaffMailer.reported_listing(report.id)
  end
end