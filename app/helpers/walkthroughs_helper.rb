# Walkthroughs Helper.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Methods added to this helper will be available to all templates in
# the walkthroughs view.
#
module WalkthroughsHelper

  # Returns the severity array.
  def severity_array
    [["Low", "0"], ["Medium", "1"], ["High", "2"], ["Critical", "3"]]
  end

  # Returns the severity string for a defined level.
  def severity_string(level=0)
    hash = {0 => "Low", 1 => "Medium", 2 => "High", 3 => "Critical"}
    hash[level]
  end

  # Return the list of columns to search for.
  def walkthroughs_search_options
    arr = []
    Walkthrough::column_names.each do |column|
      if !%w{id project_id lock_version created_at updated_at user}.include? column
        arr << [column.gsub(/[_]/, ' ').capitalize, column]
      end
    end
    arr
  end

end
