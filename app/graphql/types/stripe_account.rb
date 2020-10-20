class Types::StripeAccount < Types::ActiveRecordObject
  field :charges_enabled, Boolean, null: false
  field :onboarding_link, String, null: true
end
