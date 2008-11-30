# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081130150416) do

  create_table "authors", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "opinionated", :limit => 11
  end

  add_index "authors", ["name"], :name => "index_authors_on_name"

  create_table "eintrags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration",   :limit => 11
    t.integer  "level",      :limit => 11
  end

  create_table "feedpages", :force => true do |t|
    t.string   "url"
    t.string   "publication"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "source_id",     :limit => 11
    t.integer  "Active",        :limit => 11
    t.integer  "previous_size", :limit => 11
    t.integer  "opinionated",   :limit => 11
    t.integer  "language",      :limit => 11
    t.integer  "topic",         :limit => 11
    t.boolean  "video"
  end

  create_table "groups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight",      :limit => 11
    t.integer  "pilot",       :limit => 11
    t.integer  "topic",       :limit => 11
    t.integer  "gsession_id", :limit => 11
    t.integer  "broadness",   :limit => 11
    t.integer  "language",    :limit => 11
  end

  create_table "gsessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "haufens", :force => true do |t|
    t.integer  "weight",      :limit => 11
    t.integer  "pilot",       :limit => 11
    t.integer  "topic",       :limit => 11
    t.integer  "hsession_id", :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "members"
    t.integer  "latest",      :limit => 11
    t.integer  "broadness",   :limit => 11
    t.integer  "language",    :limit => 11
    t.integer  "videos",      :limit => 11
  end

  create_table "hsessions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "olists", :force => true do |t|
    t.text     "en"
    t.text     "de"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rawstories", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "author_id",   :limit => 11
    t.integer  "feedpage_id", :limit => 11
    t.integer  "source_id",   :limit => 11
    t.integer  "opinion",     :limit => 11
    t.integer  "language",    :limit => 11
    t.integer  "group_id",    :limit => 11
    t.integer  "haufen_id",   :limit => 11
    t.string   "keywords"
    t.integer  "titlehash",   :limit => 11
    t.integer  "linkhash",    :limit => 11
    t.boolean  "video"
  end

  add_index "rawstories", ["title"], :name => "index_rawstories_on_title", :unique => true
  add_index "rawstories", ["link"], :name => "index_rawstories_on_link", :unique => true

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "user_id",    :limit => 11
    t.integer  "author_id",  :limit => 11
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.text     "stories"
    t.text     "new_stories"
    t.boolean  "alerts"
  end

end
