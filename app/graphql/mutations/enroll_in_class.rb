module Mutations
  class EnrollInClass < BaseMutation
    argument :live_class_id, ID, required: true

    field :message, String, null: false

    def resolve(live_class_id:)
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end

      live_class = LiveClass.find_by(id: live_class_id)
      if live_class.nil?
        raise GraphQL::ExecutionError.new("404 Not Found: Class not found")
      end

      if user.trainer? || user.admin?
        Rails.logger.warn "Trainer or Admin #{user.username} tried to enroll in a class"
        raise GraphQL::ExecutionError.new("403 Forbidden: Only Students are allowed to attend classes")
      end

      if live_class.status == "Completed"
        Rails.logger.warn "Enrollment blocked: Class #{live_class.subject} is already completed"
        raise GraphQL::ExecutionError.new("422 Unprocessable Entity: This class has already finished")
      end

      if live_class.capacity.to_i <= 0
        Rails.logger.warn "Enrollment blocked: Class #{live_class.subject} is full"
        raise GraphQL::ExecutionError.new("422 Unprocessable Entity: No seats")
      end

      enrollment = Enrollment.new(user_id: user.id, live_class_id: live_class.id)
      if enrollment.save
        live_class.decrement!(:capacity)
        Rails.logger.info "Student #{user.username} successfully enrolled in #{live_class.subject}"
        { message: "Successfully checked into the live class!" }
      else
        raise GraphQL::ExecutionError.new(enrollment.errors.full_messages.join(", "))
      end
    end
  end
end
