class CreateCodeReviews < ActiveRecord::Migration
  def self.up
    create_table :code_reviews do |t|
      t.string :module,			:null => true,  :limit => 200
      t.integer :line_number,	:null => true
      t.text :description,		:null => false,	:limit => 1000,  :default => ''
      t.string :submitted_by,	:null => false, :limit => 500
      t.string :owner,			:null => false, :limit => 500
      t.string :ticket,			:null => true,  :limit => 10
      t.boolean :resolved,		:null => false, :default => 0
	  t.integer :lock_version,	:null => false, :default => 0
	  t.references :project,	:null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :code_reviews
  end
end
