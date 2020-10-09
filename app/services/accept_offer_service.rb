class AcceptOfferService
  attr_accessor :offer

  def initialize(offer)
    @offer = offer
  end

  def accept
    unless offer.listing.available?
      raise(Errors::UserInputError, 'Cannot accept already pending offer')
    end

    # Prevent accepting another offer while we process this one
    offer.listing.update(status: :pending_sale)

    intent = Stripe::PaymentIntent.capture(offer.payment_intent_id)

    offer.listing.update(status: :sold) if intent.status == 'succeeded'

    offer

  rescue ::Stripe::StripeError => e
    offer.listing.update(status: :available)
    offer.errors.add(:base, e.message)
    offer
  end
end
