class CreateTiles < ActiveRecord::Migration
  def self.up
    create_table :tiles do |t|
      t.float :lat
      t.float :lon
      t.string :csquare_code
      t.string :geohash
      t.integer :woeid
      t.datetime :explored_at
      t.float :resolution
      t.timestamps
    end
    
    add_index(:tiles,[:lat,:lon,:geohash,:csquare_code], :unique => true)
    
  end

  def self.down
    drop_table :tiles
  end
end
