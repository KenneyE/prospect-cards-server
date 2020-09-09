class StripeSubscription < StripeModel
  WEBHOOK_EVENTS = %w[
    customer.subscription.created
    customer.subscription.updated
    customer.subscription.deleted
  ].freeze

  def params_from_stripe_object(subscription)
    { token: subscription.id, plan: subscription.plan.id }.merge(
      mirrored_params(subscription)
    )
  end

  private

  def mirrored_params(subscription)
    params = %i[
      customer
      cancel_at_period_end
      current_period_start
      current_period_end
      quantity
      status
      trial_end
      created
      metadata
      discount
    ]
    params_to_hash(params, subscription)
  end
end
