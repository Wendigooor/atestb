# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Settings.minimal_purchase = 0

AgeRange.create(index: 1, age_left: 18, age_right: 24)
AgeRange.create(index: 2, age_left: 25, age_right: 34)
AgeRange.create(index: 3, age_left: 35, age_right: 44)