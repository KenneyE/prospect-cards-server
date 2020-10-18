class Mutations::SaveEmailPreferences < Mutations::BaseMutation
  argument :email_preferences, [Inputs::EmailPreferenceInput], required: true

  field :viewer, Types::User, null: false

  def resolve(email_preferences:)

  end
end