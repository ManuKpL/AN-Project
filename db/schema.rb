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

ActiveRecord::Schema.define(version: 20151206142752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "label"
    t.string   "description"
    t.string   "value"
    t.string   "more_info"
    t.string   "postcode"
    t.string   "city"
    t.string   "phone"
    t.string   "phone_2"
    t.string   "fax"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "coordinates", force: :cascade do |t|
    t.integer  "deputy_id"
    t.integer  "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "coordinates", ["address_id"], name: "index_coordinates_on_address_id", using: :btree
  add_index "coordinates", ["deputy_id"], name: "index_coordinates_on_deputy_id", using: :btree

  create_table "deputies", force: :cascade do |t|
    t.string   "civ"
    t.string   "firstname"
    t.string   "lastname"
    t.date     "birthday"
    t.string   "birthdep"
    t.integer  "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deputies", ["job_id"], name: "index_deputies_on_job_id", using: :btree

  create_table "e_addresses", force: :cascade do |t|
    t.string   "label"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "e_coordinates", force: :cascade do |t|
    t.integer  "deputy_id"
    t.integer  "e_address_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "e_coordinates", ["deputy_id"], name: "index_e_coordinates_on_deputy_id", using: :btree
  add_index "e_coordinates", ["e_address_id"], name: "index_e_coordinates_on_e_address_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "label"
    t.string   "category"
    t.string   "family"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "coordinates", "addresses"
  add_foreign_key "coordinates", "deputies"
  add_foreign_key "deputies", "jobs"
  add_foreign_key "e_coordinates", "deputies"
  add_foreign_key "e_coordinates", "e_addresses"
end
