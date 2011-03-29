class CreateEnvspecifics < ActiveRecord::Migration
  def self.up
    create_table :envspecifics do |t|
      t.string :file,			:null => false
	  t.integer :lock_version, 	:null => false, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :envspecifics
  end
end
