class Types::Listing < Types::ActiveRecordObject
  field :title, String, null: false
  field :description, String, null: false
  field :price, Integer, null: false
  field :image_urls, [String], null: false

  field :player, Types::Player, null: false
  field :offers, [Types::Offer], null: false
end
