FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "jeff_#{n}@test.com" }
    password { 'password' }
  end
end