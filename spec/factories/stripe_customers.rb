FactoryBot.define do
  factory :stripe_customer do
    user
    token { user.stripe_customer_id }
  end
end