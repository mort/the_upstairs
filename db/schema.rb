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

ActiveRecord::Schema.define(:version => 20100516214233) do

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

  create_table "pings", :force => true do |t|
    t.integer  "user_id"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "positions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "tile_id"
    t.integer  "ping_id"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "resolution",   :default => 0.01
  end

  add_index "tiles", ["lat", "lon", "geohash", "csquare_code"], :name => "index_tiles_on_lat_and_lon_and_geohash_and_csquare_code", :unique => true

end
