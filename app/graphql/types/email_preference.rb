class Types::EmailPreference < Types::ActiveRecordObject
  field :category, String, null: false
  field :subscribed, Boolean, null: false
end