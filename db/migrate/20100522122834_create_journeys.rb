class CreateJourneys < ActiveRecord::Migration
  def self.up
    create_table :journeys do |t|
      t.references :user
      t.string :token
      t.integer :status, :limit => 2
      t.timestamps
    end
  end

  def self.down
    drop_table :journeys
  end
end
