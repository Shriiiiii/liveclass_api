module Mutations
  class CreateLiveClass < BaseMutation
    argument :subject, String, required: true
    argument :trainer, String, required: true
    argument :capacity, Integer, required: true
    argument :status, String, required: true

    field :live_class, Types::LiveClassType, null: false

    def resolve(subject:, trainer:, capacity:, status:)
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end

      Rails.logger.info "Creating a new class..."
      live_class = LiveClass.new(subject: subject, trainer: trainer, capacity: capacity, status: status)
      if live_class.save
        Rails.logger.info "Class #{live_class.subject} created successfully"
        { live_class: live_class }
      else
        Rails.logger.warn "Failed to create class: Validation error"
        raise GraphQL::ExecutionError.new(live_class.errors.full_messages.join(", "))
      end
    end
  end
end
