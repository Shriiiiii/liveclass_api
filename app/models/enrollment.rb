class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :live_class
  validates :user_id, uniqueness: { scope: :live_class_id, message: "user is already registerd" }
end
