class CreatePerformances < ActiveRecord::Migration
  def self.up
    create_table :performances do |t|
      t.text :description,		:null => false, :limit => 5000
      t.string :url,			:null => true, :limit => 1000
      t.string :tester,			:null => false, :limit => 200
      t.string :environment,	:null => false, :limit => 1000
      t.boolean :pass,			:null => false, :default => 0
      t.text :results,			:null => false,	:limit => 5000
      t.references :project,	:null => false
      t.integer :lock_version,	:null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :performances
  end
end
