#
# Search Helper.
#
# Author::    Angel (mailto:amontenegro@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Methods added to this helper will be available to all templates in
# the application.
#
module SearchHelper

	DEFAULT_PARTIAL_PATH = '/shared/search_form'

	# This helper will help us to render the search_form partial
	# Parameters:
	#	partial_path: path where the partial file should be, i.e. '/shared/search_form'
	#	path: path of the current page, i.e. /projects/1/walkthroughs
	#	search_parameterl: parameter that will be used to search in the DB
	# 	dlg_path: path to the "Advanced searh" form, if this parameter is nil, the
	#			  "Advanced Search" link should not be shown in the page
	def create_search(action_path, search_parameter, options = {})
		render :partial => (options[:partial_path].nil? ? DEFAULT_PARTIAL_PATH : options[:partial_path]),
			   :locals => { :path => action_path,
			   				:search_parameter => search_parameter,
			   				:by_list => options[:by_list],
			   				:dlg_path => options[:dlg_path],
							:label => get_label(search_parameter) }
	end

  #
  def search_field_tag(by_parameter, by_list = nil)
		unless by_list.nil?
			select_tag(by_parameter, options_for_select(by_list, params[by_parameter]))
    else
			text_field_tag(by_parameter, params[by_parameter], :size => 15)
		end
	end

	private
	# It will help to determine the lable that should be used in the search form
	# depending on the parameter that we are going to search in the DB
	# If the parameter used to
	def get_label(search_parameter)
		labels = {:search_project_name => "Name:", :search_env => "Environment:"}
		label = labels[search_parameter]
		if label.nil?
			str = search_parameter.to_s
			str['search_'] = ''
			label = str.gsub('_', ' ').capitalize + ':'
		end
		return label
	end
end
