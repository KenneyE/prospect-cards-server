class FundReporterServerSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # Opt in to the new runtime (default in future graphql-ruby versions)
  use GraphQL::Execution::Interpreter
  use GraphQL::Analysis::AST
  use GraphQL::Execution::Errors

  # Add built-in connections for pagination
  use GraphQL::Pagination::Connections

  rescue_from ActiveRecord::RecordNotFound do |e, _obj, _args|
    GraphQL::ExecutionError.new(ErrorCode.log_error(e).user_message)
  end

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

  rescue_from StandardError do |e, _obj, args|
    hash_args = {}
    args.to_h.each_key do |k|
      arg = args[k]
      hash_args[k] =
        if arg.is_a?(Array)
          arg.map { |a| a.respond_to?(:to_h) ? a.to_h : a }
        else
          arg.respond_to?(:to_h) ? arg.to_h : arg
        end
    end
    GraphQL::ExecutionError.new(ErrorCode.log_error(e).user_message)
  end
end
