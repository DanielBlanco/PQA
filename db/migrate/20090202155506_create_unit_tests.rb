class CreateUnitTests < ActiveRecord::Migration
  def self.up
    create_table :unit_tests do |t|
      t.string :fsd_usecase_id,		:null => true,  :limit => 10
      t.string :module,				:null => true,  :limit => 200
      t.text :description,			:null => false,	:limit => 1000,  :default => ''
      t.text :result,				:null => false,	:limit => 1000,  :default => ''
      t.string :brands,				:null => false,	:limit => 200,  :default => 'Default'
      t.text :notes,				:null => false,	:limit => 1000,  :default => ''
	  t.integer :lock_version,		:null => false, :default => 0
	  t.references :project,		:null => false
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :unit_tests
  end
end
