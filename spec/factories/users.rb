FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jeff_#{n}@test.com" }
    password { 'password' }
    sequence(:stripe_customer_id) { |n| "cust_123#{n}" }
    confirmed_at { Time.current }
  end
end