# Put business logic of Projects in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Project Model class.
#
class Project < ActiveRecord::Base

  [:walkthroughs, :unit_tests, :code_reviews, :deployments, :performances].each do |assoc|
    has_many assoc, :dependent => :delete_all
  end

  # Validations.
  validates_length_of :name, :in => 5..50,
    :too_short  => "More than {{count}} characters if you don't mind.",
    :too_long => "Less than {{count}} characters if you don't mind."
  validates_as_ticket_number :ticket, :allow_blank => true
  validates_date :started_on
  validates_uniqueness_of :name, :message => '^Project name already exists.'
  validates_uniqueness_of :ticket, :message => 'already assigned to another project.'

  # Create a condition string and a list of arguments to seach in the Database.
  # This is a specific method for porjects, but it will be called by the "search_paginated"
  # method from the search engine.
  # Example:
  #		Input parameter:
  #			searchParamteres = { :search_module => 1, :search_owner => pablo, :search_resolved => false}
  #		Returns:
  #			conditions_and_arguments[0] = module = :module AND owner = :owner AND resolved = :resolved
  #			conditions_and_arguments[1] = {:module => 1, :owner => pablo, :resolved => false}
  def self.create_search_conditions(search_parameters)
  	conditions_and_arguments = []
  	conditions  = []
	arguments = {}
	if !search_parameters[:search_project_name].nil? && !search_parameters[:search_project_name].empty?
		conditions << "name like :search_project_name"
		arguments[:search_project_name] = "%" + search_parameters[:search_project_name] + "%"
	end
	if !search_parameters[:search_active].nil? && !search_parameters[:search_active].empty?
		conditions << "active = :search_active"
		arguments[:search_active] = search_parameters[:search_active].to_b
	end
	if !search_parameters[:from].nil? && !search_parameters[:from].empty?
		conditions << "started_on >= :from"
		arguments[:from] = Date.parse(search_parameters[:from])
	end
	if !search_parameters[:until].nil? && !search_parameters[:until].empty?
		conditions << "started_on <= :until"
		arguments[:until] = Date.parse(search_parameters[:until])
	end
	conditions = conditions.join(' AND ')
	conditions_and_arguments[0] = conditions
	conditions_and_arguments[1] = arguments
	return conditions_and_arguments
  end


  def self.export_project
  end
end
