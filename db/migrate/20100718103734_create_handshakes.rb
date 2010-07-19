class CreateHandshakes < ActiveRecord::Migration
  def self.up
    create_table :handshakes do |t|
      t.references(:user)
      t.references(:requester)
      t.references(:request)
      t.integer :status, :null => false, :default => 0
      t.datetime :broken_at
      t.timestamps
    end
  end

  def self.down
    drop_table :handshakes
  end
end
