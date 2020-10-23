class DeviseOverrideMailer < ApplicationMailer
  def confirmation_instructions(record, token, _opts = {})
    @confirmation_url = "#{_client_url}/confirm/#{token}"

    mail(to: record.email, subject: 'Welcome to Prospect Cards!')
  end

  def reset_password_instructions(record, token, _opts = {})
    @token = token
    @resource = record

    mail(to: record.email, subject: 'Prospect Cards Password Reset')
  end
end
