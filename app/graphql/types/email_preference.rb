class Types::EmailPreference < Types::ActiveRecordObject
  field :category, String, null: false
  field :canceled, Boolean, null: false
end