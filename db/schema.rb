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

ActiveRecord::Schema.define(version: 20140216051545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", force: true do |t|
    t.string   "title"
    t.integer  "number"
    t.date     "air_date"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "episodes_users", id: false, force: true do |t|
    t.integer "episode_id"
    t.integer "user_id"
  end

  create_table "seasons", force: true do |t|
    t.integer  "number"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image"
    t.boolean  "active",     default: false
  end

  create_table "shows_users", id: false, force: true do |t|
    t.integer "show_id"
    t.integer "user_id"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "username"
    t.boolean  "is_admin"
    t.string   "password_digest"
    t.string   "image"
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
