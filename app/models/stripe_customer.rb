class StripeCustomer < StripeModel
  WEBHOOK_EVENTS = %w[customer.created customer.updated customer.deleted].freeze

  belongs_to :user,
             foreign_key: :stripe_account_id,
             primary_key: :token,
             inverse_of: :stripe_customer

  def params_from_stripe_object(customer)
    { token: customer.id }
  end
end
