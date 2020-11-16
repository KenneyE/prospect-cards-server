class Types::ListingImage < Types::ActiveRecordObject
  field :urls, [String], null: false
  field :fallback_url, String, null: false

  field :position, Integer, null: false
end
