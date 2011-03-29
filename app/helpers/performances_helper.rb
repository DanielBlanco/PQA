module PerformancesHelper

  # Return the list of columns to search for.
  def performance_search_options
    arr = []
    Performance::column_names.each do |column|
      if !%w{id project_id lock_version created_at updated_at}.include? column
	    arr << [column.gsub(/[_]/, ' ').capitalize, column]
	  end
    end
    arr
  end

end
