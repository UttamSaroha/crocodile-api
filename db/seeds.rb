# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
include Faker

30.times do
  User.create!(
first_name: Faker::Name.first_name,
  last_name: Faker::Name.last_name,
  email: Faker::Internet.free_email,
  password: Faker::Internet.password,
  username: Faker::Name.first_name,
birthday: Faker::Date.birthday,
  gender: 0
  )
end