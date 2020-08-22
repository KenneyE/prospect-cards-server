require 'sendgrid-ruby'

# Top-level mailer with obligatory class-level documentation
class ApplicationMailer < ActionMailer::Base
  include SendGrid

  before_action :_skip_test

  def initialize
    super
    @mail = T.let(SendGrid::Mail.new, SendGrid::Mail)
    @personalization = T.let(Personalization.new, Personalization)

    @mail.from = T.let(Email.new(email: 'dev@test.com'), Email)
    @mail.template_id = T.let('05acb8c5-2c00-43c9-a771-29c8091879b7', String)
  end

  protected

  def _add_attachment(document)
    attachment = Attachment.new
    attachment.content =
      Base64.strict_encode64(open(document.expiring_url).read)
    attachment.type = document.content_type
    attachment.filename = document.original_filename
    attachment.disposition = 'attachment'
    attachment.content_id = document.original_filename
    @mail.add_attachment(attachment)
  end

  def _add_content_from_string(string)
    @mail.add_content(Content.new(type: 'text/html', value: string))
  end

  def _add_content_from_partial(view_path)
    @mail.add_content(
      Content.new(
        type: 'text/plain',
        value: render_to_string("#{view_path}.text.erb", layout: false)
      )
    )
    @mail.add_content(
      Content.new(
        type: 'text/html',
        value: render_to_string("#{view_path}.html.erb", layout: false)
      )
    )
  end

  def _add_to_emails(emails)
    emails.each { |email| @personalization.add_to(Email.new(email: email)) }
  end

  def _send_email
    @mail.add_personalization(@personalization)

    return unless Rails.env.production?

    sg =
      SendGrid::API.new(
        api_key: ENV['SENDGRID_API_KEY'], host: 'https://api.sendgrid.com'
      )
    response = sg.client.mail._('send').post(request_body: @mail.to_json)
    _puts_response_info(response)
  end

  private

  def _puts_response_info(response)
    puts '========================= EMAIL RESPONSE ========================='
    puts 'Status', response.status_code
    puts 'Body', response.body
    puts 'Headers', response.headers
    puts '========================= EMAIL RESPONSE ========================='
  end

  def _skip_test
    mail.perform_deliveries = false if Rails.env.test?
  end
end
