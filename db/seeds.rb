# Clear existing data to prevent duplicate validation errors
Enrollment.destroy_all
User.destroy_all
LiveClass.destroy_all

# Create Users with proper database roles
student = User.create!(
  username: "shridhar",
  password: "password123",
  role: :student,
  session_key: SecureRandom.hex(10)
)

trainer1 = User.create!(
  username: "manoj",
  password: "password123",
  role: :trainer,
  session_key: SecureRandom.hex(10)
)

trainer2 = User.create!(
  username: "gagan",
  password: "password123",
  role: :trainer,
  session_key: SecureRandom.hex(10)
)

# live cls
LiveClass.create!(
  subject: "Ruby on Rails Basics",
  trainer: "gagan",
  capacity: 5,
  status: "Scheduled"
)

LiveClass.create!(
  subject: "Advanced Database Design",
  trainer: "manoj",
  capacity: 0,
  status: "Scheduled"
)

LiveClass.create!(
  subject: "Intro to HTML",
  trainer: "gagan",
  capacity: 10,
  status: "Completed"
)

LiveClass.create!(
  subject: "React Foundations",
  trainer: "manoj",
  capacity: 15,
  status: "Active"
)

puts "Database seeded successfully!"
puts "Created Student: shridhar (password: password123)"
puts "Created Trainer 1: manoj (password: password123)"
puts "Created Trainer 2: gagan (password: password123)"
