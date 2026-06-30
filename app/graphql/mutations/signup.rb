module Mutations
  class Signup < BaseMutation
    argument :username, String, required: true
    argument :password, String, required: true
    argument :role, String, required: false

    field :message, String, null: false

    def resolve(username:, password:, role: "student")
      user = User.new(username: username, password: password)
      user.role = role if role.present?
      user.session_key = SecureRandom.hex(10)

      if user.save
        Rails.logger.info "User #{user.username} registered successfully"
        { message: "User created successfully" }
      else
        raise GraphQL::ExecutionError.new(user.errors.full_messages.join(", "))
      end
    end
  end
end
