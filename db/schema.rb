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

ActiveRecord::Schema.define(version: 20150429185118) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "episodes", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.integer  "number"
    t.date     "air_date"
    t.integer  "season_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "number"
    t.integer  "show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shows", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image"
    t.boolean  "active",                 default: false
    t.integer  "rage_id"
    t.string   "nickname",   limit: 255
  end

  create_table "shows_users", id: false, force: :cascade do |t|
    t.integer "show_id"
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",         limit: 255
    t.string   "last_name",          limit: 255
    t.string   "email",              limit: 255
    t.string   "username",           limit: 255
    t.boolean  "is_admin"
    t.string   "password_digest",    limit: 255
    t.string   "image",              limit: 255
    t.string   "auth_token",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "queue_oldest_first",             default: true
  end

  create_table "watched_episodes", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "episode_id"
  end

  create_table "watched_seasons", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "season_id"
  end

  create_table "watched_shows", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "show_id"
  end

end
