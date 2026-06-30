# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Node query endpoints (standard for GraphQL generators)
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Custom Query Fields matching the REST endpoints
    field :live_classes, [Types::LiveClassType], null: false, description: "List all live classes"
    field :live_class, Types::LiveClassType, null: false, description: "Get a specific live class" do
      argument :id, ID, required: true
    end
    field :my_classes, [Types::LiveClassType], null: false, description: "Get live classes the current student is enrolled in"

    # Resolvers
    def live_classes
      require_user!
      Rails.logger.info "Fetching all classes"
      classes = LiveClass.all
      Rails.logger.debug "Total classes loaded: #{classes.count}"
      classes
    end

    def live_class(id:)
      require_user!
      Rails.logger.info "Fetching class details for ID: #{id}"
      LiveClass.find(id)
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error "Class ID #{id} not found"
      raise GraphQL::ExecutionError.new("404 Not Found: requested session not found")
    end

    def my_classes
      user = require_user!
      Rails.logger.info "Student #{user.username} is getting their schedule"
      user.live_classes
    end

    private

    # Helper to enforce authorization context
    def require_user!
      user = context[:current_user]
      if user.nil?
        raise GraphQL::ExecutionError.new("401 Unauthorized: Access token is invalid or session has been killed")
      end
      user
    end
  end
end
