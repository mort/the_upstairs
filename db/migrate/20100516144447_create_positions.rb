class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.references :user
      t.references :tile
      t.references :ping
      t.timestamps
    end
  end

  def self.down
    drop_table :positions
  end
end
