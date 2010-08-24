class AddUserIdToFeedItems < ActiveRecord::Migration
  def self.up
    add_column :feed_items, :user_id, :integer
  end

  def self.down
    remove_column :feed_items, :user_id
  end
end
