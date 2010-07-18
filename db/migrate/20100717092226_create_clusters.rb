class CreateClusters < ActiveRecord::Migration
  def self.up
    create_table :clusters do |t|
      t.references :tile
      t.string :cluster_type
      t.float :lat
      t.float :lon
    end
  end

  def self.down
    drop_table :clusters
  end
end
