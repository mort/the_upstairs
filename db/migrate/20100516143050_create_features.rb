class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.references :tile
      t.string :service
      t.string :type
      t.string :title
      t.float :lat
      t.float :lon
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
