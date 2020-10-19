FactoryBot.define do
  factory :stripe_payment_intent do
    sequence(:token) { |n| "pi_abc#{n}" }
    stripe_customer
    amount { 1_000 }
    client_secret { 'abc123' }
    metadata { {} }
    status { 'succeeded' }
  end
end
