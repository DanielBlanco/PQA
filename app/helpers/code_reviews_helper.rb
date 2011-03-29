# Code Review Helper.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Methods added to this helper will be available to all templates in 
# the views/code_reviews folder.
#
module CodeReviewsHelper

  # Return the list of columns to search for.
  def code_review_search_options
    arr = []
    CodeReview::column_names.each do |column|
      if !%w{id project_id lock_version created_at updated_at}.include? column
	    arr << [column.gsub(/[_]/, ' ').capitalize, column]
	  end
    end
    arr
  end

end
