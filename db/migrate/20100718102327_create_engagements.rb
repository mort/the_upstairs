class CreateEngagements < ActiveRecord::Migration
  def self.up
    create_table :engagements do |t|
      t.references(:user)
      t.references(:requester)
      t.references(:request)
      t.integer :status, :null => false, :default => 0
      t.datetime :finished_at
      t.timestamps
    end
  end

  def self.down
    drop_table :engagements
  end
end
