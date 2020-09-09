class Types::Membership < Types::ActiveRecordObject
  field :token, String, null: false
  field :price, Integer, null: false
  field :term, String, null: false
end



