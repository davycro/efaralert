# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "creating admin named david"
admin = Admin.new(full_name: 'David Crockett', 
  email: 'me@davecro.com', 
  password: 'colorado',
  password_confirmation: 'colorado')
if admin.save
  puts "success"
else
  puts "failed"
end