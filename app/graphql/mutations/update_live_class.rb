module Mutations
  class UpdateLiveClass < BaseMutation
    argument :id, ID, required: true
    argument :subject, String, required: false
    argument :trainer, String, required: false
    argument :capacity, Integer, required: false
    argument :status, String, required: false

    field :live_class, Types::LiveClassType, null: false

    def resolve(id:, **attributes)
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end

      Rails.logger.info "Updating class ID: #{id}"
      live_class = LiveClass.find(id)
      if live_class.update(attributes)
        Rails.logger.info "Class ID #{id} updated successfully"
        { live_class: live_class }
      else
        Rails.logger.warn "Update failed for class ID: #{id}"
        raise GraphQL::ExecutionError.new(live_class.errors.full_messages.join(", "))
      end
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Class ID #{id} not found"
      raise GraphQL::ExecutionError.new("404 Not Found: requested session not found")
    end
  end
end
