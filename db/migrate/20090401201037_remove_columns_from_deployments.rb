class RemoveColumnsFromDeployments < ActiveRecord::Migration
  def self.up
    remove_column :deployments, :module
    remove_column :deployments, :ticket
    remove_column :deployments, :ticket_type
  end

  def self.down
    add_column :deployments, :module, :string, :null => false, :limit => 200, :default => ''
    add_column :deployments, :ticket,	:string, :null => false, :limit => 10
    add_column :deployments, :ticket_type,	:string, :null => false, :limit => 200
  end
end
