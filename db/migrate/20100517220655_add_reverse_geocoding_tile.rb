class AddReverseGeocodingTile < ActiveRecord::Migration
  def self.up
    add_column :tiles, :reverse_geocoding_data, :text
  end

  def self.down
    remove_column :tiles, :reverse_geocoding_data
  end
end
