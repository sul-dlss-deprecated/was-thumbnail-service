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

ActiveRecord::Schema.define(version: 20150120175616) do

  create_table "mementos", force: true do |t|
    t.integer  "uri_id"
    t.datetime "memento_datetime"
    t.string   "memento_uri"
    t.boolean  "is_selected"
    t.boolean  "is_thumbnail_captured"
    t.integer  "simhash_value",                    limit: 8
    t.datetime "last_thumbnail_captured_datetime"
    t.integer  "retry_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seed_uris", force: true do |t|
    t.string   "uri"
    t.string   "druid_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
