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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140515175359) do

  create_table "log_lines", :force => true do |t|
    t.integer  "match_id"
    t.text     "line"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "log_lines", ["created_at"], :name => "index_log_lines_on_created_at"
  add_index "log_lines", ["match_id"], :name => "index_log_lines_on_match_id"

  create_table "matches", :force => true do |t|
    t.string   "host"
    t.string   "rcon"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stats_events", :force => true do |t|
    t.integer  "log_line_id"
    t.integer  "match_id"
    t.datetime "time"
    t.string   "event_type"
    t.string   "player_name"
    t.string   "player_steam_id"
    t.string   "player_team"
    t.string   "target_name"
    t.string   "target_steam_id"
    t.string   "target_team"
    t.string   "cap_number"
    t.string   "cap_name"
    t.text     "message"
    t.text     "unknown"
    t.string   "team"
    t.string   "score"
    t.integer  "value"
    t.string   "item"
    t.string   "role"
    t.integer  "length"
    t.string   "method"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "healing"
    t.boolean  "ubercharge"
    t.string   "weapon"
    t.string   "customkill"
    t.boolean  "airshot"
  end

  add_index "stats_events", ["created_at"], :name => "index_stats_events_on_created_at"
  add_index "stats_events", ["event_type"], :name => "index_stats_events_on_event_type"
  add_index "stats_events", ["log_line_id"], :name => "index_stats_events_on_log_line_id"
  add_index "stats_events", ["match_id"], :name => "index_stats_events_on_match_id"
  add_index "stats_events", ["player_steam_id"], :name => "index_stats_events_on_player_steam_id"
  add_index "stats_events", ["time"], :name => "index_stats_events_on_time"

end
