class OffersMailer < ApplicationMailer
  include EmailPreferences::Mailer

  categorize as: :your_offers_and_purchases

  def offer_accepted(offer_id)
    @offer = Offer.find(offer_id)

    mail(to: @offer.user.email, subject: 'Your offer was accepted!')
  end

  def buy_now_confirmation(offer_id)
    @offer = Offer.find(offer_id)

    mail(to: @offer.user.email, subject: 'Purchase confirmed')
  end
end
