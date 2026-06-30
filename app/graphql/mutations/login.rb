module Mutations
  class Login < BaseMutation
    argument :username, String, required: true
    argument :password, String, required: true

    field :token, String, null: false
    field :username, String, null: false

    def resolve(username:, password:)
      Rails.logger.info "Login started for user: #{username}"
      user = User.find_by(username: username)

      if user && user.authenticate(password)
        new_key = SecureRandom.hex(10)
        user.update!(session_key: new_key)
        token = JsonWebToken.encode(user_id: user.id, session_key: new_key)
        Rails.logger.info "User #{user.username} logged in successfully"
        { token: token, username: user.username }
      else
        Rails.logger.warn "Login failed for user: #{username}"
        raise GraphQL::ExecutionError.new("401 Unauthorized: Invalid username or password")
      end
    end
  end
end
