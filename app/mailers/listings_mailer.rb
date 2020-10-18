class ListingsMailer < ApplicationMailer
  include EmailPreferences::Mailer

  categorize as: :listing_offers_and_updates

  def offer_received(offer_id)
    @offer = Offer.find(offer_id)

    mail(to: @offer.listing.user.email, subject: "You've received an offer!")
  end
end
