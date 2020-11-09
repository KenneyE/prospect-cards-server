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
      brand: payment_method.card.brand,
      exp_month: payment_method.card.exp_month,
      exp_year: payment_method.card.exp_year,
      last4: payment_method.card.last4,
    }
  end
end
