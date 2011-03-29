class AddModuleToDeploymentsTable < ActiveRecord::Migration
  def self.up
    add_column :deployments, :module, :string, :null => false, :limit => 200, :default => ''
  end

  def self.down
    remove_column :deployments, :module
  end
end
