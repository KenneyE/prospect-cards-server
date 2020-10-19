class AcceptOfferService
  attr_accessor :offer

  def initialize(offer)
    @offer = offer
  end

  def accept
    _verify_availability

    # Prevent accepting another offer while we process this one
    offer.listing.update(status: :pending_sale)

    intent = Stripe::PaymentIntent.capture(offer.payment_intent_id)

    offer.listing.update(status: :sold) if intent.status == 'succeeded'
    offer
  rescue ::Stripe::StripeError => e
    _handle_stripe_error(e)
  end

  private

  def _handle_stripe_error(error)
    offer.listing.update(status: :available)
    offer.errors.add(:base, error.message)
    offer
  end

  def _verify_availability
    return if offer.listing.available?

    raise(Errors::UserInputError, 'Cannot accept already pending offer')
  end
end
