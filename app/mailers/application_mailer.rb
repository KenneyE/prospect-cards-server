# Top-level mailer with obligatory class-level documentation
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@prospect.cards'
  layout 'mailer'

  protected

  def _add_to_emails(emails)
    emails = Array(emails)
    emails.each { |email| @personalization.add_to(Email.new(email: email)) }
  end

  def _client_url
    Rails.application.credentials.dig(:app, :client_url)
  end
end
