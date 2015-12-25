# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151225184635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "addresses", force: :cascade do |t|
    t.string   "label"
    t.string   "description"
    t.string   "value"
    t.string   "more_info"
    t.string   "postcode"
    t.string   "city"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "original_tag"
    t.integer  "deputy_id"
  end

  add_index "addresses", ["deputy_id"], name: "index_addresses_on_deputy_id", using: :btree

  create_table "deputies", force: :cascade do |t|
    t.string   "civ"
    t.string   "firstname"
    t.string   "lastname"
    t.date     "birthday"
    t.string   "birthdep"
    t.integer  "job_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "original_tag"
    t.string   "screen_name"
  end

  add_index "deputies", ["job_id"], name: "index_deputies_on_job_id", using: :btree

  create_table "e_addresses", force: :cascade do |t|
    t.string   "label"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "deputy_id"
  end

  add_index "e_addresses", ["deputy_id"], name: "index_e_addresses_on_deputy_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "label"
    t.string   "category"
    t.string   "family"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organes", force: :cascade do |t|
    t.string   "original_tag"
    t.string   "label"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "phones", force: :cascade do |t|
    t.string   "label"
    t.string   "value"
    t.integer  "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "phones", ["address_id"], name: "index_phones_on_address_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "addresses", "deputies"
  add_foreign_key "deputies", "jobs"
  add_foreign_key "e_addresses", "deputies"
  add_foreign_key "phones", "addresses"
end
