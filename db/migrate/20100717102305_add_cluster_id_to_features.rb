class AddClusterIdToFeatures < ActiveRecord::Migration
  def self.up
    add_column :features, :cluster_id, :integer
  end

  def self.down
    remove_column :features, :cluster_id
  end
end
