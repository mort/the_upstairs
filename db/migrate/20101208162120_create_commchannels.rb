class CreateCommchannels < ActiveRecord::Migration
  def self.up
    create_table :commchannels do |t|
      t.references :context, :polymorphic => true
      t.timestamps
    end
  end

  def self.down
    drop_table :commchannels
  end
end
