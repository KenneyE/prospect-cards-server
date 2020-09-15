# Error handling
module GraphqlErrors
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def self.rescue
    # rubocop:disable Metrics/BlockLength
    proc do
      rescue_from ActiveRecord::RecordNotFound do |e, _obj, _args|
        GraphQL::ExecutionError.new(ErrorCode.log_error(e).user_message)
      end

      rescue_from Exceptions::MutationException do |e|
        GraphQL::ExecutionError.new(e)
      end

      rescue_from Exceptions::InvalidInput do |e|
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
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
