class Types::Product < Types::BaseObject
  field :token, String, null: false
  field :price, Integer, null: false
  field :term, String, null: false
end
