class ApplicationController < ActionController::API
  # authorizing method
  def authorize_request
    # taking autherization header
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    
    # decodinf
    decoded = JsonWebToken.decode(token) if token

    if decoded
      # Find the user matching the ID inside the token 
      @current_user = User.find_by(id: decoded[:user_id])
      
      # check key matches with the db key
      if @current_user && @current_user.session_key == decoded[:session_key]
        return true # if Match found allow 
      end
    end

    # if anything fail;s
    logger.warn " [WARN]  Invalid, expired token "
    render json: { error: "401 Unauthorized: Access token is invalid or session has been killed" }, status: :unauthorized
  end
end