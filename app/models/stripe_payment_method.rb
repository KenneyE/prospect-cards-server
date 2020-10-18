class StripePaymentMethod < StripeModel
  WEBHOOK_EVENTS = %w[
    payment_method.attached
    payment_method.automatically_updated
    payment_method.detached
    payment_method.updated
  ].freeze

  belongs_to :stripe_customer,
             foreign_key: :customer,
             primary_key: :token,
             inverse_of: :stripe_payment_methods

  delegate :user, to: :stripe_customer

  def params_from_stripe_object(payment_method)
    {
      token: payment_method.id,
      customer: payment_method.customer,
    }
  end
end
