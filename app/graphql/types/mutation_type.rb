# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # Auth Mutations
    field :signup, mutation: Mutations::Signup
    field :login, mutation: Mutations::Login
    field :logout, mutation: Mutations::Logout

    # Live Class Mutations
    field :create_live_class, mutation: Mutations::CreateLiveClass
    field :update_live_class, mutation: Mutations::UpdateLiveClass
    field :delete_live_class, mutation: Mutations::DeleteLiveClass

    # Enrollment Mutation
    field :enroll_in_class, mutation: Mutations::EnrollInClass
  end
end
