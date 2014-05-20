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

ActiveRecord::Schema.define(version: 20140515163631) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar"
    t.string   "email"
    t.string   "role",             default: "unapproved"
  end

  create_table "awards", force: true do |t|
    t.text     "notes"
    t.integer  "participant_id"
    t.integer  "experience_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
  end

  create_table "participants", force: true do |t|
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "library_card"
    t.string   "email"
    t.integer  "zip_code"
    t.string   "home_library"
    t.string   "school"
    t.string   "grade"
    t.string   "club"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birth_date",      default: '2011-01-01'
    t.boolean  "got_reading_kit", default: false
    t.boolean  "got_final_prize", default: false
  end

end