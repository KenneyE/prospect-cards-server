class Mutations::SaveProfilePicture < Mutations::BaseMutation
  argument :picture, ApolloUploadServer::Upload, required: true

  field :viewer, Types::User, null: false

  def resolve(picture:)
    user = current_user
    user.profile_picture.attach(
      io: picture['document'].to_io, filename: picture['document'].original_filename,
    )
    raise_errors(user)

    { viewer: user, message: 'Photo updated' }
  end
end
