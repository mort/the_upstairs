class AddActionsToFeedItems < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :actions, :text
  end

  def self.down
    remove_column :feed_ites, :actions
  end
end
