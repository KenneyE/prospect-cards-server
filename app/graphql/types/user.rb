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
end