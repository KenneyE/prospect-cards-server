class Types::User < Types::ActiveRecordObject
  field :listings, [Types::Listing], null: false
  field :stripe_account, Types::StripeAccount, null: false
end