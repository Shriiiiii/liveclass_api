# Clear existing data to prevent duplicate validation errors
Enrollment.destroy_all
User.destroy_all
LiveClass.destroy_all

# Create Users with proper database roles
student = User.create!(
  username: "john",
  password: "password123",
  role: :student,
  session_key: SecureRandom.hex(10)
)

trainer = User.create!(
  username: "bob",
  password: "password123",
  role: :trainer,
  session_key: SecureRandom.hex(10)
)

# Create Live Classes for various testing scenarios
LiveClass.create!(
  subject: "Ruby on Rails Basics",
  trainer: "Trainer Bob",
  capacity: 5,
  status: "Scheduled"
)

LiveClass.create!(
  subject: "Advanced Database Design",
  trainer: "Trainer Bob",
  capacity: 0,
  status: "Scheduled"
)

LiveClass.create!(
  subject: "Intro to HTML",
  trainer: "Trainer Bob",
  capacity: 10,
  status: "Completed"
)

LiveClass.create!(
  subject: "React Foundations",
  trainer: "Trainer Bob",
  capacity: 15,
  status: "Active"
)

puts "Database seeded successfully!"
puts "Created Student: john (password: password123)"
puts "Created Trainer: bob (password: password123)"
