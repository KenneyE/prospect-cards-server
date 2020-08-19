class Types::User < Types::ActiveRecordObject
  field :listings, [Types::Listing], null: false
end