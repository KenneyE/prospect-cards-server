class Types::Listing < Types::ActiveRecordObject
  field :title, String, null: false
  field :description, String, null: false
  field :image_urls, [String], null: false
end
