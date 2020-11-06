class Mutations::SaveProfile < Mutations::BaseMutation
  argument :profile, Inputs::ProfileInput, required: true

  field :viewer, Types::User, null: false

  def resolve(profile:)
    user = current_user
    user.update(profile.to_h)
    raise_errors(user)

    { viewer: user, message: 'Profile saved!' }
  end
end
