FactoryBot.define do
  factory :listing do
    title { 'Listing Title' }
    description { 'Listing Desc' }
    price { 12_345 }
    user
    product_type_list { ['Set'] }
    manufacturer_list { ['Tops']}
    set_type_list { ['Prizm'] }
    category_list { ['Baseball'] }
    player_list { ['Cal Ripken Jr'] }
  end
end
