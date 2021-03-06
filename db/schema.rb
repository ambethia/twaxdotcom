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

ActiveRecord::Schema.define(version: 20141019192924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "faxes", force: true do |t|
    t.integer  "user_id"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phaxio_id"
    t.string   "fax_number"
    t.string   "metadata"
    t.json     "payload"
  end

  create_table "hacks", force: true do |t|
    t.string "name"
    t.text   "value"
  end

  add_index "hacks", ["name"], name: "index_hacks_on_name", using: :btree

  create_table "inbound_mails", force: true do |t|
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outgoing_tweets", force: true do |t|
    t.integer  "user_id"
    t.integer  "fax_id"
    t.string   "message"
    t.datetime "tweeted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "tweet_id"
  end

  add_index "outgoing_tweets", ["fax_id"], name: "index_outgoing_tweets_on_fax_id", using: :btree
  add_index "outgoing_tweets", ["user_id"], name: "index_outgoing_tweets_on_user_id", using: :btree

  create_table "pages", force: true do |t|
    t.integer  "fax_id"
    t.string   "file"
    t.text     "extracted_text"
    t.datetime "text_extracted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "role"
    t.string   "token"
    t.string   "secret"
    t.json     "oauth_data"
    t.string   "phaxio_barcode_url"
    t.string   "nickname"
    t.integer  "faxes_sent_count",   default: 0
  end

end
