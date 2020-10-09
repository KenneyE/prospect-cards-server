require('sendgrid-ruby')

# Top-level mailer with obligatory class-level documentation
class ApplicationMailer < ActionMailer::Base
  include SendGrid

  before_action :_skip_test

  def initialize
    super
    @mail = SendGrid::Mail.new
    @personalization = Personalization.new

    _set_sandbox_mode

    @mail.from = Email.new(email: 'info@prospect.cards')
    @mail.template_id = 'd-cc26d7b564684c86a8664f32abf28527'
  end

  protected

  def _add_attachment(document)
    attachment = Attachment.new
    attachment.content =
      Base64.strict_encode64(File.open(document.expiring_url).read)
    attachment.type = document.content_type
    attachment.filename = document.original_filename
    attachment.disposition = 'attachment'
    attachment.content_id = document.original_filename
    @mail.add_attachment(attachment)
  end

  def _add_content_from_string(string)
    @mail.add_content(Content.new(type: 'text/html', value: string))
  end

  def _add_content(view_path, locals = {})
    _add_text_content(view_path, locals)
    _add_html_content(view_path, locals)
  end

  def _add_to_emails(emails)
    emails = Array(emails)
    emails.each { |email| @personalization.add_to(Email.new(email: email)) }
  end

  def _client_url
    Rails.application.credentials.dig(:app, :client_url)
  end

  def _send_email
    @mail.add_personalization(@personalization)

    sg =
      SendGrid::API.new(
        api_key: Rails.application.credentials.dig(:sendgrid, :api_key),
        host: 'https://api.sendgrid.com',
      )

    response = sg.client.mail._('send').post(request_body: @mail.to_json)
    _puts_response_info(response)
  end

  private

  def _add_html_content(view_path, locals)
    @mail.add_content(
      Content.new(
        type: 'text/html',
        value: render_to_string("/mailers/#{view_path}.html.erb", layout: false, locals: locals),
      ),
    )
  end

  def _add_text_content(view_path, locals)
    @mail.add_content(
      Content.new(
        type: 'text/plain',
        value: render_to_string("/mailers/#{view_path}.text.erb", layout: false, locals: locals),
      ),
    )
  end

  def _puts_response_info(response)
    logger.info('=================== EMAIL RESPONSE =====================')
    logger.info("Status: #{response.status_code}")
    logger.info('-----Body----')
    logger.info(response.body)
    logger.info('-----Headers-----')
    logger.info(response.headers)
    logger.info('=================== EMAIL RESPONSE =====================')
  end

  def _skip_test
    mail.perform_deliveries = false if Rails.env.test?
  end

  def _set_sandbox_mode
    return if Rails.env.production?

    mail_settings = MailSettings.new
    mail_settings.sandbox_mode = SandBoxMode.new(enable: true)
    @mail.mail_settings = mail_settings
  end
end
