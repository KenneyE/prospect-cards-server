# typed: ignore
# Helper methods for testing graphql request specs
module GraphqlHelpers
  # Used for `type: :request` specs that include GraphqlHelpers
  # Use `expect_error` for `type: :graphql` tests
  def expect_error_message(message)
    errors = JSON.parse(response.body)['errors']
    expect(errors).not_to be_nil, 'Expected errors to be present, got nil'

    messages = errors.map { |err| err['message'] }
    expect(messages).to include(message)
  end

  def expect_query_result(
    query, expected, variables: {}, context: {}, schema: FundReporterServerSchema
  )
    result =
      execute_query(
        query,
        variables: variables, context: context, schema: schema,
      )
    expect(result['errors']).to be_nil
    expect(result['data']).to eq(expected.as_json)
  end
  alias expects_query_result expect_query_result

  def execute_query(
    query, variables: {}, context: {}, schema: FundReporterServerSchema
  )
    # Has access to `let`s
    context[:current_user] ||= user if defined?(user)

    schema.execute(query, variables: variables, context: context)
  end

  def expect_error(
    query, expected, variables: {}, context: {}, schema: FundReporterServerSchema
  )
    result =
      execute_query(
        query,
        variables: variables, context: context, schema: schema,
      )

    expect(result['errors'][0]['message']).to eq(expected)
  end
end
