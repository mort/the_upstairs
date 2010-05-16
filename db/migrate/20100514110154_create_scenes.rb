class CreateScenes < ActiveRecord::Migration
  def self.up
    create_table :scenes do |t|
      t.references(:tile)
      t.text :content
      t.string :checksum
      t.timestamps
    end
    
    add_index(:scenes,[:checksum],:unique => true)
  end

  def self.down
    drop_table :scenes
  end
end
