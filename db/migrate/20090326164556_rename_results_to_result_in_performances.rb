class RenameResultsToResultInPerformances < ActiveRecord::Migration
  def self.up
    rename_column :performances, :results, :result
  end

  def self.down
    rename_column :performances, :result, :results
  end
end
