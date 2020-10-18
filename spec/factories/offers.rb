FactoryBot.define do
  factory :offer do
    user
    listing
    price { 1_000 }
    stripe_payment_intent
  end
end