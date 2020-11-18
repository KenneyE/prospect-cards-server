class DeviseOverrideMailer < ApplicationMailer
  def confirmation_instructions(record, token, _opts = {})
    @confirmation_url = "#{_client_url}/confirm/#{token}"

    mail(to: record.email, subject: 'Welcome to Prospect Cards!')
  end

  def reset_password_instructions(record, token, _opts = {})
    @token = token
    @resource = record

    mail(to: record.email, subject: 'Prospect Cards - Password Reset')
  end

  def invitation_instructions(record, token, _opts = {})
    @accept_url = "#{_client_url}/accept-invitation/#{token}"

    mail(
      to: record.email, subject: "You've been invited to join Prospect Cards!",
    )
  end
end
