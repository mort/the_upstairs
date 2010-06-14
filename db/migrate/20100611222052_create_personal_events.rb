class CreatePersonalEvents < ActiveRecord::Migration
  def self.up
    create_table :personal_events do |t|
      t.references(:user)
      t.string :event_type
      t.text :body
      t.boolean :actionable
      t.integer :status, :limit => 1, :null => false, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :personal_events
  end
end
