class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.references :journey
      t.references :position
      t.references :user
      t.references :presence, :null => true
      t.string :title, :null => true
      t.string :feed_item_type, :null => false, :default => ''
      t.text :body, :null => false, :default => ''
      t.string :scope, :null => true
      t.boolean :actionable, :default => false
      t.datetime :read_at
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
