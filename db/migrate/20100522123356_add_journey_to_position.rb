class AddJourneyToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :journey_id, :integer
    remove_column :positions, :user_id
  end

  def self.down
    remove_column :positions, :journey_id
    add_column :positions, :user_id, :integer
  end
end
