module SearchEngine
	def self.included(base)
		class << base

			# Generic search engine that will search the database based in a list of parameters
			# Parameters:
			#	searchParameter: An array of parameters that should be used to search the db
			def search(search_parameters)
				unless search_parameters.nil?
      				conditions = create_search_conditions(search_parameters)
      				find(:all, :conditions => [conditions[0], conditions[1]], :order => :id)
      			else
      				find(:all, :order => :id)
     			end
			end

			# Generic search engine that will search the database based in a list of parameters and
			# it will paginate the list
			# Parameters:
			#	search_parameters: An array of parameters that should be used to search the db
			#   page:
			def search_paginated(search_parameters, page=1)

				# If page is less than 1 or is not an Integer, show the first page.
				if page.nil? or page.is_a?(Integer) or page.to_i < 0
				  page = 1
				end

				unless search_parameters.nil?
      				conditions = create_search_conditions(search_parameters)
      				paginate :per_page => records_per_page, :page => page,
					         :conditions => [conditions[0], conditions[1]],
							 :order => :id
      			else
      				paginate :per_page => records_per_page, :page => page,
					         :order => :id
     			end
			end

			# Create a condition string and a list of arguments to seach in the Database
  			# Example:
  			#		Input parameter:
		  	#			searchParamteres = { :search_module => 1, :search_owner => pablo, :search_resolved => false}
		  	#		Returns:
		  	#			conditions_and_arguments[0] = module = :module AND owner = :owner AND resolved = :resolved
		  	#			conditions_and_arguments[1] = {:module => 1, :owner => pablo, :resolved => false}
			def create_search_conditions(search_parameters)
				conditions_and_arguments = []
				conditions  = []
				arguments = {}
				create_search_conditions_hash().each do |key, value|
					if !search_parameters[key].nil? && !search_parameters[key].empty?
						if(search_parameters[key].to_b != nil)
							conditions << "#{value} = :#{key}"
							arguments[key] = search_parameters[key].to_b
						else
							conditions << "#{value} like :#{key}"
							arguments[key] = "%" + search_parameters[key] + "%"
						end
					end
				end
				conditions = conditions.join(' AND ')
				conditions_and_arguments[0] = conditions
				conditions_and_arguments[1] = arguments
				return conditions_and_arguments
			end

			# Returns a Hash table that contain all the posible fields that will be usead to search in the db
			def create_search_conditions_hash()
				return {:search_project_name => 'name', :search_issue_id => 'issue', :search_module => 'module',
						:search_env => 'environment', :search_line_number => 'line_number', :search_description => 'description',
						:search_url => 'url', :search_submitted_by => 'submitted_by', :search_result => 'result',
						:search_owner => 'owner', :search_pass_brands => "pass_brands", :search_fail_brands => 'fail_brands',
						:search_severity => 'severity', :search_fsd_usecase_id => 'fsd_usecase_id', :search_ticket => 'ticket',
						:search_notes => 'notes', :search_active => 'active', :search_tester => 'tester',
						:search_resolved => 'resolved', :search_pass_flag => 'pass', :search_file => 'file',
						:search_name => 'name'}
			end
		end
	end
end

ActiveRecord::Base.send :include, SearchEngine
