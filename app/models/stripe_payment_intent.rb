class StripePaymentIntent < StripeModel
  WEBHOOK_EVENTS = %w[
    payment_intent.amount_capturable_updated
    payment_intent.canceled
    payment_intent.created
    payment_intent.payment_failed
    payment_intent.processing
    payment_intent.requires_action
    payment_intent.succeeded
  ].freeze

  def params_from_stripe_object(intent)
    { token: intent.id }.merge(mirrored_params(intent))
  end

  private

  def mirrored_params(subscription)
    params = %i[
      amount
      client_secret
      customer
      metadata
      status
      on_behalf_of
      transfer_group
    ]
    params_to_hash(params, subscription)
  end
end
