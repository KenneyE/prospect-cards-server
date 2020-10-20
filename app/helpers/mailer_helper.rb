module MailerHelper
  def client_url
    Rails.application.credentials.dig(:app, :client_url)
  end
end
