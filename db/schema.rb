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

ActiveRecord::Schema.define(version: 20170508020919) do

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.string   "backend"
    t.decimal  "cpu",                precision: 10, scale: 2
    t.integer  "mem"
    t.integer  "disk"
    t.string   "cmd"
    t.string   "args"
    t.integer  "priority"
    t.string   "runas"
    t.string   "constraints"
    t.string   "image"
    t.string   "network"
    t.text     "portmappings"
    t.boolean  "force_image"
    t.boolean  "privileged"
    t.text     "env"
    t.text     "volumes"
    t.text     "uris"
    t.text     "gateway"
    t.text     "health_check"
    t.integer  "instances"
    t.integer  "service_id"
    t.integer  "current_version_id"
    t.text     "raw_config"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "state"
  end

  create_table "audits", force: :cascade do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "when"
    t.string   "entity_type"
    t.integer  "entity_id"
    t.string   "enetity_desc"
    t.text     "change"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.string   "name"
    t.string   "hash"
    t.integer  "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "hostname"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "registries", force: :cascade do |t|
    t.string   "name"
    t.string   "hash"
    t.integer  "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "icon"
    t.integer  "group_id"
    t.integer  "user_id"
    t.text     "raw_config"
    t.string   "desc"
    t.text     "readme"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",         null: false
    t.text     "value"
    t.string   "target_type", null: false
    t.integer  "target_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target_type_and_target_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "tagable_type"
    t.integer  "tagable_id"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "salt"
    t.string   "encrypted_password"
    t.text     "icon"
    t.text     "bio"
    t.string   "role"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

end
