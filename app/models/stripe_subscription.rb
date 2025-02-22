class StripeSubscription < StripeModel
  ACTIVE_STATES = %w[active trialing past_due].freeze
  WEBHOOK_EVENTS = %w[
    customer.subscription.created
    customer.subscription.updated
    customer.subscription.deleted
  ].freeze

  MIRRORED_PARAMS = %i[
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
  ].freeze

  belongs_to :user,
             foreign_key: :customer,
             primary_key: :stripe_customer_id,
             inverse_of: :user

  def params_from_stripe_object(subscription)
    { token: subscription.id, plan: subscription.plan.id }.merge(
      mirrored_params(subscription),
    )
  end

  def active?
    ACTIVE_STATES.include?(status) && quantity.positive?
  end

  private

  def mirrored_params(subscription)
    params_to_hash(MIRRORED_PARAMS, subscription)
  end
end
