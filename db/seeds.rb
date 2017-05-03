# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#
require 'faker'

Faker::Config.locale

1.upto(200) do |i|
  Node.create hostname: "114.55.130.152", state: 'active'
end
