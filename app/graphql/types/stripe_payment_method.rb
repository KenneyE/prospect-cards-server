class Types::StripePaymentMethod < Types::ActiveRecordObject
  field :brand, String, null: false
  field :exp_month, Integer, null: false
  field :exp_year, Integer, null: false
  field :last4, String, null: false
end
