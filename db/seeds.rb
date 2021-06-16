# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(
  name: 'Admin', email: 'admin@admin.com', bio: 'Usuário admnistrador do sistema',
  password: '12345678', password_confirmation: '12345678'
)
user.image.attach(io: File.open('./public/admin-profile.jpg'), filename: 'admin-profile.jpg ')
