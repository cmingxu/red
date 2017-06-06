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

ActiveRecord::Schema.define(version: 20170606080946) do

  create_table "app_links", force: :cascade do |t|
    t.integer  "service_id"
    t.string   "alias"
    t.integer  "input_app_id"
    t.integer  "output_app_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

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
    t.string   "slug"
    t.index ["service_id"], name: "index_apps_on_service_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "when"
    t.string   "entity_type"
    t.string   "enetity_desc"
    t.string   "action"
    t.text     "change"
    t.integer  "entity_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["entity_id"], name: "index_audits_on_entity_id"
    t.index ["entity_type", "entity_id"], name: "index_audits_on_entity_type_and_entity_id"
    t.index ["user_id"], name: "index_audits_on_user_id"
  end

  create_table "group_users", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.integer  "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "owner_id"
    t.text     "desc"
    t.string   "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.index ["owner_id"], name: "index_groups_on_owner_id"
  end

  create_table "namespaces", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_namespaces_on_group_id"
    t.index ["user_id"], name: "index_namespaces_on_user_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.string   "hostname"
    t.string   "state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
    t.integer  "cpu"
    t.integer  "mem"
    t.string   "docker_version"
    t.string   "pubkey"
  end

  create_table "permissions", force: :cascade do |t|
    t.string   "resource_type"
    t.integer  "resource_id"
    t.integer  "access"
    t.string   "accessor_type"
    t.integer  "accessor_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["accessor_type", "accessor_id"], name: "index_permissions_on_accessor_type_and_accessor_id"
    t.index ["resource_type", "resource_id"], name: "index_permissions_on_resource_type_and_resource_id"
  end

  create_table "repo_tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "repository_id"
    t.integer  "namespace_id"
    t.integer  "blob_size"
    t.string   "owner_name"
    t.string   "digest"
    t.string   "url"
    t.string   "source"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.integer  "namespace_id"
    t.string   "latest_tag_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["namespace_id"], name: "index_repositories_on_namespace_id"
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
    t.string   "slug"
    t.index ["group_id"], name: "index_service_templates_on_group_id"
    t.index ["user_id"], name: "index_service_templates_on_user_id"
  end

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.string   "desc"
    t.boolean  "favorite"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.index ["group_id"], name: "index_services_on_group_id"
    t.index ["user_id"], name: "index_services_on_user_id"
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

  create_table "sites", force: :cascade do |t|
    t.string   "docker_public_key"
    t.text     "mesos_addrs"
    t.text     "marathon_addrs"
    t.string   "graphna_addr"
    t.string   "mesos_state"
    t.string   "marathon_state"
    t.string   "graphna_state"
    t.datetime "mesos_last_seen"
    t.datetime "marathon_last_seen"
    t.datetime "graphna_last_seen"
    t.text     "changelog"
    t.string   "version"
    t.text     "feature_flags"
    t.string   "mesos_leader_url"
    t.string   "marathon_leader_url"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
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

  create_table "versions", force: :cascade do |t|
    t.string   "name"
    t.text     "raw_config"
    t.integer  "app_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_versions_on_app_id"
  end

end
