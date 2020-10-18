class DeviseOverrideMailer < ApplicationMailer
  def confirmation_instructions(record, token, _opts = {})
    @confirmation_url = "#{_client_url}/confirm/#{token}"

    mail(to: record.email, subject: 'Welcome to Prospect Cards!')
  end
end
