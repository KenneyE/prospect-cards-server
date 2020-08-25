class Types::QueryType < Types::BaseObject
  field :auth, Boolean, null: false
  def auth
    context[:current_user].present?
  end

  field :viewer, Types::User, null: false
  def viewer
    context[:current_user]
  end

  field :stripe_checkout_session_id, String, null: false
  def stripe_checkout_session_id
      Stripe::Checkout::Session.create(
        payment_method_types: %w[card],
        mode: 'setup',
        customer: viewer.stripe_customer_id,
        success_url: "#{client_url}/account/payment_added",
        cancel_url: "#{client_url}/account/add_payment"
      ).id
  end
end
