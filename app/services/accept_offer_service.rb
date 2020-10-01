class AcceptOfferService
  attr_accessor :offer

  def initialize(offer)
    @offer = offer
  end

  def accept
    unless offer.listing.available?
      raise(InvalidOfferError, 'Cannot accept already pending offer')
    end

    offer.listing.update(status: :pending_sale)

    intent = Stripe::PaymentIntent.capture(offer.payment_intent_id)

    offer.listing.update(status: :sold) if intent.status == 'succeeded'

    offer

  rescue ::Stripe::StripeError => e
    offer.errors.add(:base, e.message)
    offer
  end
end
