class RemoveDefaultValueForNameInProjects < ActiveRecord::Migration
  def self.up
    remove_column :projects, :name 
    add_column    :projects, :name, :string, :null => false, :limit => 100
  end

  def self.down
    remove_column :projects, :name 
    add_column    :projects, :name, :string, :null => false, :limit => 200, :default => "Untitled!"
  end
end
