class CreateCollectedVcards < ActiveRecord::Migration
  def self.up
    create_table :collected_vcards do |t|
      t.references :user
      t.references :vcard_owner
      t.timestamps
    end
  end

  def self.down
    drop_table :collected_vcards
  end
end
