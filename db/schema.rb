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

ActiveRecord::Schema.define(version: 20140301200939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "match_availabilities", force: true do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "available"
    t.integer  "team_id"
  end

  add_index "match_availabilities", ["match_id"], name: "index_match_availabilities_on_match_id", using: :btree
  add_index "match_availabilities", ["team_id"], name: "index_match_availabilities_on_team_id", using: :btree
  add_index "match_availabilities", ["user_id"], name: "index_match_availabilities_on_user_id", using: :btree

  create_table "match_lineups", force: true do |t|
    t.string   "match_type", default: "", null: false
    t.integer  "ordinal",                 null: false
    t.integer  "match_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "team_id"
  end

  add_index "match_lineups", ["match_id"], name: "index_match_lineups_on_match_id", using: :btree
  add_index "match_lineups", ["team_id"], name: "index_match_lineups_on_team_id", using: :btree

  create_table "match_players", force: true do |t|
    t.integer  "user_id"
    t.integer  "match_lineup_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "team_id"
  end

  add_index "match_players", ["match_lineup_id"], name: "index_match_players_on_match_lineup_id", using: :btree
  add_index "match_players", ["team_id"], name: "index_match_players_on_team_id", using: :btree
  add_index "match_players", ["user_id"], name: "index_match_players_on_user_id", using: :btree

  create_table "match_sets", force: true do |t|
    t.integer  "games_won"
    t.integer  "games_lost"
    t.integer  "ordinal",         null: false
    t.integer  "match_lineup_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "team_id"
  end

  add_index "match_sets", ["team_id"], name: "index_match_sets_on_team_id", using: :btree

  create_table "matches", force: true do |t|
    t.datetime "date",                                 null: false
    t.text     "location",              default: "",   null: false
    t.integer  "team_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "notified_state"
    t.boolean  "home_team",             default: true
    t.text     "comment"
    t.string   "notified_lineup_state"
    t.string   "opponent",              default: ""
  end

  add_index "matches", ["team_id"], name: "index_matches_on_team_id", using: :btree

  create_table "practice_sessions", force: true do |t|
    t.integer  "user_id"
    t.integer  "practice_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "team_id"
    t.boolean  "available"
  end

  add_index "practice_sessions", ["practice_id"], name: "index_practice_sessions_on_practice_id", using: :btree
  add_index "practice_sessions", ["team_id"], name: "index_practice_sessions_on_team_id", using: :btree
  add_index "practice_sessions", ["user_id"], name: "index_practice_sessions_on_user_id", using: :btree

  create_table "practices", force: true do |t|
    t.datetime "date",                       null: false
    t.text     "comment"
    t.integer  "team_id",        default: 0, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "notified_state"
    t.text     "location"
  end

  add_index "practices", ["team_id"], name: "index_practices_on_team_id", using: :btree

  create_table "team_members", force: true do |t|
    t.integer  "team_id",    default: 0,        null: false
    t.integer  "user_id",    default: 0,        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "role",       default: "member"
    t.string   "state",      default: "new",    null: false
  end

  add_index "team_members", ["team_id"], name: "index_players_on_team_id", using: :btree
  add_index "team_members", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name",            default: "", null: false
    t.datetime "date",                         null: false
    t.integer  "singles_matches",              null: false
    t.integer  "doubles_matches",              null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "email",           default: "", null: false
  end

  create_table "users", force: true do |t|
    t.string   "first_name",             default: ""
    t.string   "last_name",              default: ""
    t.string   "phone_number"
    t.string   "email",                  default: "",                           null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                    null: false
    t.datetime "updated_at",                                                    null: false
    t.string   "time_zone",              default: "Eastern Time (US & Canada)"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
