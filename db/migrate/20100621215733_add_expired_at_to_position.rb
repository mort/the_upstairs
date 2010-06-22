class AddExpiredAtToPosition < ActiveRecord::Migration
  def self.up
    add_column :positions, :expired_at, :datetime
  end

  def self.down
    remove_column :positions, :expired_at  
  end
end
