FactoryBot.define do
  factory :email_preference do
    user
    category { 'Seller emails' }
    subscribed { true }
  end
end