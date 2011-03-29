class ChangeResolvedDefaultValueTo0ForWalkthroughTable < ActiveRecord::Migration
  def self.up
  	change_column :walkthroughs, :resolved, :boolean, :null => false, :default => 0
  end

  def self.down
  	change_column :walkthroughs, :resolved, :boolean, :null => false, :default => 1
  end
end
