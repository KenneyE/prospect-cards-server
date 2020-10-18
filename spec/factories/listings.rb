FactoryBot.define do
  factory :listing do
    title { 'Listing Title' }
    description { 'Listing Desc' }
    price { 12_345 }
    user
    product_type
    manufacturer
    set_type
    category
    player
  end
end