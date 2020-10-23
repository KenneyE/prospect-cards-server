class FundReporterServerSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  use GraphQL::Execution::Errors

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections
  use GraphQL::Guard.new

  # rescue_from ActiveRecord::RecordNotFound do |_e, _obj, _args|
  #   GraphQL::ExecutionError.new('Internal server error')
  # end

  rescue_from Errors::UserInputError do |e|
    GraphQL::ExecutionError.new(e)
  end

  rescue_from Errors::ConfirmationError do |e|
    GraphQL::ExecutionError.new(e)
  end

  # validation errors
  rescue_from ActiveRecord::RecordInvalid do |e|
    # If we just get e.message, it joins errors with a comma and
    # adds "Validation failed:". Here we join with a new line instead.
    errors =
      e.record.errors.full_messages.join("\n")
    GraphQL::ExecutionError.new(errors)
  end

  # rescue_from StandardError do |_e, _obj, args|
  #   GraphQL::ExecutionError.new('Internal server error')
  # end
end
