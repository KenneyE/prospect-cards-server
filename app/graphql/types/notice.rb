class Types::Notice < Types::ActiveRecordObject
  field :title, String, null: false
  field :text, String, null: false
  field :path, String, null: true
end
