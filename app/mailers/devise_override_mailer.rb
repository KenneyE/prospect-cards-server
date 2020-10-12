class DeviseOverrideMailer < ApplicationMailer
  def confirmation_instructions(record, token, _opts = {})
    @mail.subject = 'Welcome to Prospect Cards!'

    _add_to_emails(record.email)
    _add_content(
      '/devise_override/confirmation_instructions',
      confirmation_url: "#{_client_url}/confirm/#{token}",
    )

    _send_email
  end
end
