class DeviseOverrideMailer < ApplicationMailer
  def confirmation_instructions(record, token, _opts = {})
    @mail.subject = 'Welcome to Prospect Cards!'

    # For now, also send copy to me for verification.
    @personalization.add_bcc(Email.new(email: 'e.kenney@prospect.cards'))
    _add_to_emails(record.email)
    _add_content(
      '/devise_override/confirmation_instructions',
      confirmation_url: "#{_client_url}/confirm/#{token}",
    )

    _send_email
  end
end
