# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
default_kanari_admin = User.create(email: 'admin@kanari.co', password: 'admin123', password_confirmation: 'admin123', role: 'kanari_admin')

CuisineType.create([
  { name: "International" },
  { name: "Chinese" },
  { name: "Japanese" },
  { name: "Italian" },
  { name: "Lebanese" },
  { name: "Indian" },
  { name: "Steakhouse" }
])

OutletType.create([
  { name: "Cafe" },
  { name: "Fine Dining" },
  { name: "Casual Dining" },
  { name: "Fast-Casual" },
  { name: "Lebanese" },
  { name: "Indian" },
  { name: "Steakhouse" }
])
