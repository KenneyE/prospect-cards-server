FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jeff_#{n}@test.com" }
    password { 'password' }
    stripe_customer_id { 'cust_123' }
  end
end