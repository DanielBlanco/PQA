class RenameTtrackToTicketInProjects < ActiveRecord::Migration
  def self.up
    rename_column :projects, :ttrack, :ticket
  end

  def self.down
    rename_column :projects, :ticket, :ttrack
  end
end
