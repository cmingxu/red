# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#
require 'faker'

Faker::Config.locale

1.upto(200) do |i|
  Product.create name: Faker::Name.name,
    sku: "0001%03d" % i,
    desc: Faker::Lorem.paragraph,
    price: 100,
    origin_price: 98,
    quantity: 100,
    app: App.root_app
end
