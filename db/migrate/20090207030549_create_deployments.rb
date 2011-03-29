class CreateDeployments < ActiveRecord::Migration
  def self.up
    create_table :deployments do |t|
      t.string :file,					:null => false,  :limit => 500
      t.string :file_type,				:null => false,  :limit => 200
      t.boolean :environment_specific,	:null => false,  :default => false
      t.string :action,					:null => false,  :limit => 20
      t.string :ticket,					:null => false,  :limit => 10
      t.string :ticket_type,			:null => false,  :limit => 200
	  t.integer :lock_version,			:null => false,  :default => 0
	  t.references :project,			:null => false
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :deployments
  end
end
