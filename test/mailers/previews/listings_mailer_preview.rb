class ListingsMailerPreview < ActionMailer::Preview
  def offer_received
    offer = Offer.first
    ListingsMailer.with(subscriber_id: User.first.id).offer_received(offer.id)
  end
end