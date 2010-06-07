class CreatePublicMessages < ActiveRecord::Migration
  def self.up
    create_table :public_messages do |t|
      t.references(:tile)
      t.text :body
      t.timestamps
    end
  end

  def self.down
    drop_table :public_messages
  end
end
