class StripeCustomer < StripeModel
  WEBHOOK_EVENTS = %w[customer.created customer.updated customer.deleted].freeze

  belongs_to :user,
             primary_key: :token,
             foreign_key: :stripe_account_id,
             inverse_of: :stripe_customer

  def params_from_stripe_object(customer)
    { token: customer.id }
  end
end
