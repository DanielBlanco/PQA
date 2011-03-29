class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :name,			:null => false, :unique => true
      t.text :values,			:null => false
      t.integer :lock_version, 	:null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :configurations
  end
end
