class ListingsMailer < ApplicationMailer
  include EmailPreferences::Mailer

  categorize as: :listing_offers_and_updates

  def offer_received(offer_id)
    offer = Offer.find(offer_id)

    @mail.subject = "You've received an offer!"

    _add_to_emails(offer.listing.user.email)
    _add_content('/listings/offer_received', offer: offer)

    _send_email
  end
end
