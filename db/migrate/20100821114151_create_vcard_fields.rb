class CreateVcardFields < ActiveRecord::Migration
  def self.up
    create_table :vcard_fields do |t|
      t.references :user
      t.string :name
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :vcard_fields
  end
end
