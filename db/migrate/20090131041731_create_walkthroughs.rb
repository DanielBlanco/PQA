class CreateWalkthroughs < ActiveRecord::Migration
  def self.up
    create_table :walkthroughs do |t|
      t.string :issue,			:null => true,  :limit => 10
      t.text :description,		:null => false,	:limit => 1000,  :default => ''
      t.string :url,			:null => true,  :limit => 500
      t.integer :severity
      t.text :user,				:null => false,	:limit => 1000,  :default => ''
      t.string :owner,			:null => false, :limit => 500
      t.boolean :resolved,		:null => false, :default => 1
	  t.integer :lock_version,	:null => false, :default => 0
	  t.references :project,	:null => false
	  
      t.timestamps
    end
  end

  def self.down
    drop_table :walkthroughs
  end
end
