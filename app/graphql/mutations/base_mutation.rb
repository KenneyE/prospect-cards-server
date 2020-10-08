class Mutations::BaseMutation < GraphQL::Schema::Mutation
  field :message, String, null: false

  def current_user
    context[:current_user]
  end

  def raise_errors(model)
    return if model.errors.empty?

    raise(Errors::UserInputError, model.errors.full_messages.join("\n"))
  end

  protected

  def require_confirmation!
    # TODO: Uncomment when confirmation emails are actually going out.
    return if current_user.confirmed?

    raise(
      Errors::ConfirmationError,
      'Please confirm your email address and try again.',
    )
  end
end
