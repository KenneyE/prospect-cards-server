class Types::Offer < Types::ActiveRecordObject
  field :price, Integer, null: false
  field :listing, Types::Listing, null: false
end
