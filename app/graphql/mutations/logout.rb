module Mutations
  class Logout < BaseMutation
    field :message, String, null: false

    def resolve
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end

      Rails.logger.info "User #{user.username} logged out"
      killed_key = SecureRandom.hex(10)
      user.update!(session_key: killed_key)
      Rails.logger.debug "Session key changed in database"
      { message: "Logged out successfully." }
    end
  end
end
