class V1::GraphqlController < ApplicationController
  before_action :authenticate_user!, except: :schema

  def execute
    result = execute_query
    render(json: result)
  rescue StandardError => e
    raise(e) unless Rails.env.development?

    handle_error_in_development(e)
  end

  def schema
    throw(:warden) unless Rails.env.development?

    result = execute_query
    render(json: result)
  rescue StandardError => e
    raise(e) unless Rails.env.development?

    handle_error_in_development(e)
  end

  private

  def execute_query
    FundReporterServerSchema.execute(
      params[:query],
      variables: prepare_variables(params[:variables]),
      context: { current_user: current_user },
      operation_name: params[:operationName],
    )
  end

  # Handle variables in form data, JSON body, or a blank value
  # rubocop:disable Metrics/MethodLength
  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) || {} : {}
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise(ArgumentError, "Unexpected parameter: #{variables_param}")
    end
  end
  # rubocop:enable Metrics/MethodLength

  def handle_error_in_development(err)
    logger.error(err.message)
    logger.error(err.backtrace.join("\n"))

    render(json: {
             errors: [{ message: err.message, backtrace: err.backtrace }], data: {}
           },
           status: :internal_server_error)
  end
end
