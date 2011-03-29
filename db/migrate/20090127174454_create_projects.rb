class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name,			:null => false, :limit => 200, :default => "Untitled!"
      t.date :started_on,		:null => true,  :default => nil
      t.string :ttrack,			:null => true,  :limit => 10, :default => nil
      t.boolean :active,		:null => false, :default => 1
      t.integer :lock_version, 	:null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
