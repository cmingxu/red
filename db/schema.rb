# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170405133310) do

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "owner"
    t.string   "contact"
    t.string   "appid"
    t.string   "token"
    t.datetime "last_active_time"
    t.string   "last_active_ip"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.string   "sku"
    t.text     "desc"
    t.decimal  "price"
    t.decimal  "origin_price"
    t.boolean  "is_publish"
    t.integer  "quantity"
    t.integer  "app_id"
    t.string   "icon1"
    t.string   "icon2"
    t.string   "icon3"
    t.string   "icon4"
    t.string   "icon5"
    t.string   "icon6"
    t.string   "icon7"
    t.string   "icon8"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
