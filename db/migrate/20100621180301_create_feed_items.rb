class CreateFeedItems < ActiveRecord::Migration
  def self.up
    create_table :feed_items do |t|
      t.references :journey
      t.string :title
      t.string :feed_item_type
      t.text :body
      t.boolean :actionable
      t.datetime :read_at
      t.timestamps
    end
  end

  def self.down
    drop_table :feed_items
  end
end
