class ListingsMailer < ApplicationMailer
  include EmailPreferences::Mailer

  categorize as: :your_listings_and_incoming_offers

  def offer_received(offer_id)
    @offer = Offer.find(offer_id)

    mail(to: @offer.listing.user.email, subject: "You've received an offer!")
  end

  def buy_now(offer_id)
    @offer = Offer.find(offer_id)

    mail(to: @offer.listing.user.email, subject: 'Your listing was purchased!')
  end
end
