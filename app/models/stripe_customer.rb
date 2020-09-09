class StripeCustomer < StripeModel
  WEBHOOK_EVENTS = %w[customer.created customer.updated customer.deleted].freeze

  def params_from_stripe_object(customer)
    { token: customer.id }
  end
end
