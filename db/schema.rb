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

ActiveRecord::Schema.define(:version => 20100606093029) do

  create_table "activity_stream_preferences", :force => true do |t|
    t.string   "activity"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_preferences", ["activity", "user_id"], :name => "activity_stream_preferences_idx"

  create_table "activity_stream_totals", :force => true do |t|
    t.string   "activity"
    t.integer  "object_id"
    t.string   "object_type"
    t.float    "total",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_totals", ["activity", "object_id", "object_type"], :name => "activity_stream_totals_idx"

  create_table "activity_streams", :force => true do |t|
    t.string   "verb"
    t.string   "activity"
    t.integer  "actor_id"
    t.string   "actor_type"
    t.string   "actor_name_method"
    t.integer  "count",                       :default => 1
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "object_name_method"
    t.integer  "indirect_object_id"
    t.string   "indirect_object_type"
    t.string   "indirect_object_name_method"
    t.string   "indirect_object_phrase"
    t.integer  "status",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_streams", ["actor_id", "actor_type"], :name => "activity_streams_by_actor"
  add_index "activity_streams", ["indirect_object_id", "indirect_object_type"], :name => "activity_streams_by_indirect_object"
  add_index "activity_streams", ["object_id", "object_type"], :name => "activity_streams_by_object"

  create_table "client_applications", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          :limit => 20
    t.string   "secret",       :limit => 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], :name => "index_client_applications_on_key", :unique => true

  create_table "features", :force => true do |t|
    t.integer  "tile_id"
    t.string   "service"
    t.string   "type"
    t.string   "title"
    t.float    "lat"
    t.float    "lon"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "journeys", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.integer  "status",     :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "oauth_nonces", :force => true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], :name => "index_oauth_nonces_on_nonce_and_timestamp", :unique => true

  create_table "oauth_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "type",                  :limit => 20
    t.integer  "client_application_id"
    t.string   "token",                 :limit => 20
    t.string   "secret",                :limit => 40
    t.string   "callback_url"
    t.string   "verifier",              :limit => 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], :name => "index_oauth_tokens_on_token", :unique => true

  create_table "pings", :force => true do |t|
    t.integer  "user_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.integer  "tile_id"
    t.integer  "ping_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "journey_id"
  end

  create_table "presences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "venue_id"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "public_messages", :force => true do |t|
    t.integer  "tile_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scenes", :force => true do |t|
    t.integer  "tile_id"
    t.text     "content"
    t.string   "checksum"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenes", ["checksum"], :name => "index_scenes_on_checksum", :unique => true

  create_table "tiles", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.string   "csquare_code"
    t.string   "geohash"
    t.integer  "woeid"
    t.datetime "explored_at"
    t.float    "resolution"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reverse_geocoding_data"
  end

  add_index "tiles", ["lat", "lon", "geohash", "csquare_code"], :name => "index_tiles_on_lat_and_lon_and_geohash_and_csquare_code", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "email",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
    t.string   "single_access_token",                  :null => false
    t.string   "perishable_token",                     :null => false
    t.integer  "login_count",           :default => 0, :null => false
    t.integer  "failed_login_count",    :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_stream_token"
  end

end
