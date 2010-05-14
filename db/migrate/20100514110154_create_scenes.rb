class CreateScenes < ActiveRecord::Migration
  def self.up
    create_table :scenes do |t|
      t.references(:tile)
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :scenes
  end
end
