class Inputs::EmailPreferenceInput < Types::BaseInputObject
  argument :category, String, required: true
  argument :subscribed, Boolean, required: true
end
