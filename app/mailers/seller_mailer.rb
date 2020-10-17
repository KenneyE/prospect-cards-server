class SellerMailer < ApplicationMailer
  include EmailPreferences::Mailer

  categorize as: :seller_notification

  def offer_received
    _send_email
  end
end