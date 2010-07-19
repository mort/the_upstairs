class CreateUserRequests < ActiveRecord::Migration
  def self.up
    create_table :user_requests do |t|
      t.references(:user)
      t.references(:requester)
      t.string :type, :null => false, :default => ''
      t.integer :status, :null => false, :default => 0
      t.datetime :accepted_at
      t.datetime :declined_at
      t.timestamps
    end
  end

  def self.down
    drop_table :user_requests
  end
end
