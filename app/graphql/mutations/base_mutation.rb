class Mutations::BaseMutation < GraphQL::Schema::Mutation
  field :message, String, null: false

  def current_user
    context[:current_user]
  end

  def raise_errors(model)
    return if model.errors.empty?

    raise(Errors::UserInputError, model.errors.full_messages.first)

    # model.errors.full_messages.each do |error|
    #   raise Errors::UserInputError, error
    # end
  end
end
