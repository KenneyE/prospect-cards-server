class StripeCustomer < StripeModel
  WEBHOOK_EVENTS = %w[customer.created customer.updated customer.deleted].freeze

  belongs_to :user,
             foreign_key: :token,
             primary_key: :stripe_customer_id,
             inverse_of: :stripe_customer

  has_many :stripe_payment_methods,
           foreign_key: :customer,
           primary_key: :token,
           inverse_of: :stripe_customer,
           dependent: :destroy

  def params_from_stripe_object(customer)
    {
      token: customer.id,
    }
  end
end
