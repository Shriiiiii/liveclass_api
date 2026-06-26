class LiveClass < ApplicationRecord
    has_many :enrollments
    has_many :users, through: :enrollments
    validates :subject, presence: true
  validates :status, inclusion: { in: %w[Scheduled Active Completed] }
end
