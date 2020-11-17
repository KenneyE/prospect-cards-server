class Types::Purchase < Types::ActiveRecordObject
  field :offer, Types::Offer, null: false
  field :listing, Types::Listing, null: false
end
