class CreatePresences < ActiveRecord::Migration
  def self.up
    create_table :presences do |t|
      t.references(:user)
      t.references(:venue)
      t.datetime :finished_at
      t.timestamps
    end
  end

  def self.down
    drop_table :presences
  end
end
