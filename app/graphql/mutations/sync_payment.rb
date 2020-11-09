class Mutations::SyncPayment < Mutations::BaseMutation
  argument :payment_method_id, String, required: true

  field :viewer, Types::User, null: false
  def resolve(payment_method_id:)
    pm = Stripe::PaymentMethod.retrieve(payment_method_id)
    StripePaymentMethod.sync(pm)

    { viewer: current_user, message: 'Payment saved!' }
  end
end