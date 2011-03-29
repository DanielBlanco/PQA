class ChangeValuesToConfigValuesInConfigurationsTable < ActiveRecord::Migration
  def self.up
    rename_column :configurations, :values, :config_values
  end

  def self.down
    rename_column :configurations, :config_values, :values
  end
end
