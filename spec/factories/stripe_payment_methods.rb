FactoryBot.define do
  factory :stripe_payment_method do
    sequence(:token) { |n| "pm_abc#{n}" }
    customer { 'cust_123' }
  end
end