class Types::User < Types::ActiveRecordObject
  field :listings, [Types::Listing], null: false
  field :stripe_account, Types::StripeAccount, null: false do
    argument :refresh, Boolean, required: false
  end
  def stripe_account(refresh: false)
    if refresh
      object.stripe_account.refresh
    end

    object.stripe_account
  end

  field :payment_intent, String, null: false
  def payment_intent
    intent =
      Stripe::PaymentIntent.create(
        {
          customer: StripeCustomer.last.token,
          payment_method: 'card_1HKQLUIFW5W5DEYQlAItRjUz',
          amount: 10_000,
          currency: 'usd',
          transfer_group: '{ORDER10}'
        }
      )

    intent.client_secret
  end
end