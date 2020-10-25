# Preview all emails at http://localhost:3000/rails/mailers/offers_mailer
class OffersMailerPreview < ActionMailer::Preview
  def offer_accepted
    offer = Offer.first
    OffersMailer.with(subscriber_id: User.first.id).offer_accepted(offer.id)
  end
end
