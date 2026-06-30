# frozen_string_literal: true

class GraphqlController < ApplicationController
  # If accessing from outside this domain, nullify the session
  # This allows for outside API access while preventing CSRF attacks,
  # but you'll have to authenticate your user separately
  # protect_from_forgery with: :null_session

  def execute
    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: determine_current_user
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = LiveclassApiSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

    def determine_current_user
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?
    decoded = JsonWebToken.decode(token) if token
    if decoded
      user = User.find_by(id: decoded[:user_id])
      if user
        if user.session_key == decoded[:session_key]
          return user
        else
          logger.warn " [DEBUG] Session Key misssmatch DB: '#{user.session_key}', Token: '#{decoded[:session_key]}' "
        end
      else
        logger.warn " [DEBUG] User with ID #{decoded[:user_id]} not found "
      end
    else
      logger.warn " [DEBUG] Token could not be decoded. Token sent: '#{token}' "
    end
    nil
  end


  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
