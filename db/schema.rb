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

ActiveRecord::Schema.define(:version => 20100510113433) do

  create_table "tiles", :force => true do |t|
    t.float    "lat"
    t.float    "lon"
    t.string   "csquare_code"
    t.string   "geohash"
    t.integer  "woe_id"
    t.datetime "explored_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tiles", ["lat", "lon", "geohash", "csquare_code"], :name => "index_tiles_on_lat_and_lon_and_geohash_and_csquare_code", :unique => true

end
