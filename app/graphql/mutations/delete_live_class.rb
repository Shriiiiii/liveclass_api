module Mutations
  class DeleteLiveClass < BaseMutation
    argument :id, ID, required: true

    field :id, ID, null: false

    def resolve(id:)
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end

      Rails.logger.warn "Deleting class ID: #{id}"
      live_class = LiveClass.find(id)
      live_class.destroy
      { id: id }
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Class ID #{id} not found"
      raise GraphQL::ExecutionError.new("404 Not Found: requested session not found")
    end
  end
end
