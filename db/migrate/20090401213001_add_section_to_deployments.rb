class AddSectionToDeployments < ActiveRecord::Migration
  def self.up
    add_column :deployments, :section, :string
  end

  def self.down
    remove_column :deployments, :section
  end
end
