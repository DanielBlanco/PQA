module PaginationUtils
  def self.included(base)
	class << base
      #_________________________________________________________________

      # Returns the last paginated page number.
      def last_page
		extra_page = count % records_per_page == 0 ? 0 : 1
        (count / records_per_page) + extra_page
      end

	  private

	  # Returns the number of items to return per page.
	  def records_per_page
		pn = Configuration.pagination_number
		return pn.config_values.to_i if pn
		10 #=> 10 if there is not a pagination_number object.
	  end

      #_________________________________________________________________
    end
  end
end

ActiveRecord::Base.send :include, PaginationUtils
