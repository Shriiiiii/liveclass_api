class AuthenticationController < ApplicationController
  before_action :authorize_request, only: [ :logout ]

  def signup
    user = User.new(signup_params)
    user.session_key = SecureRandom.hex(10)

    if user.save
      logger.info "[INFO] Success: New User '#{user.username}' registered successfully"
      render json: { message: "User created successfully" }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    logger.info " [INFO] Login started for user: #{params[:username]} "

    user = User.find_by(username: params[:username])

    # Checking if the user exists and the password is correct
    if user && user.authenticate(params[:password])
      # Create a new session key
      new_key = SecureRandom.hex(10)
      user.update!(session_key: new_key)

      # isssue the token containing the user_id and newsession_key
      token = JsonWebToken.encode(user_id: user.id, session_key: new_key)

      logger.info " [INFO] Login Successful: Token generated for #{user.username} "
      render json: { token: token, username: user.username }, status: :ok
    else
      logger.warn " [WARN] Login Failed: Invalid credentials for user: #{params[:username]} "
      render json: { error: "401 Unauthorized: Invalid username or password" }, status: :unauthorized
    end
  end

  def logout
    logger.info " [INFO] Logout triggeerd for user: #{@current_user.username} "

    # changingg the session key after logout in the db
    killed_key = SecureRandom.hex(10)
    @current_user.update!(session_key: killed_key)

    logger.info " [INFO] DB session_key chnagedd successfully "
    render json: { message: "Logged out successfully." }, status: :ok
  end

  private

  def signup_params
    permitted_data = params.permit(:username, :password)

    if params.keys.excluding("controller", "action").sort != permitted_data.keys.sort
      logger.warn " [WARN] attenpting to add a dta that is not required"
    end

    permitted_data
  end
end
