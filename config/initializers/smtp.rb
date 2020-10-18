ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey',
  :password => Rails.application.credentials.dig(:sendgrid, :api_key),
  :domain => 'prospect.cards',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}