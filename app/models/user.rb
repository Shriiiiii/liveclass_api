class User < ApplicationRecord
    has_secure_password
    enum :role, { student: 0, trainer: 1, admin: 2 }, default: :student

    has_many :enrollments
    has_many :live_classes, through: :enrollments

    validates :username, presence: true, uniqueness: true
end
