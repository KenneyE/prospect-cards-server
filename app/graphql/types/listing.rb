class Types::Listing < Types::ActiveRecordObject
  field :title, String, null: false
  field :description, String, null: false
end