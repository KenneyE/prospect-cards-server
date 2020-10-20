class Types::ListingReport < Types::ActiveRecordObject
  field :text, String, null: false
  field :reviewed_at, GraphQL::Types::ISO8601DateTime, null: true
end
