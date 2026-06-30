module Types
  class LiveClassType < Types::BaseObject
    field :id, ID, null: false
    field :subject, String, null: false
    field :trainer, String, null: false
    field :capacity, Integer, null: false
    field :status, String, null: false
    field :users, [Types::UserType], null: false
  end
end
