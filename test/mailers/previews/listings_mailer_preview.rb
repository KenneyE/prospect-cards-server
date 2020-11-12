# Preview all emails at http://localhost:3000/rails/mailers/listings_mailer
class ListingsMailerPreview < ActionMailer::Preview
  def offer_received
    offer = Offer.first
    ListingsMailer.with(subscriber_id: User.first.id).offer_received(offer.id)
  end

  def buy_now
    offer = Offer.first
    ListingsMailer.with(subscriber_id: User.first.id).buy_now(offer.id)
  end
end
