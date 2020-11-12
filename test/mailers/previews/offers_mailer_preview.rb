# Preview all emails at http://localhost:3000/rails/mailers/offers_mailer
class OffersMailerPreview < ActionMailer::Preview
  def offer_accepted
    offer = Offer.first
    OffersMailer.with(subscriber_id: User.first.id).offer_accepted(offer.id)
  end

  def buy_now_confirmation
    offer = Offer.first
    OffersMailer.with(subscriber_id: User.first.id).buy_now_confirmation(
      offer.id,
    )
  end
end
