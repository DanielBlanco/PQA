# Put business logic of Configurations in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Configuration Model class.
#
class Configuration < ActiveRecord::Base

  # Constants
  BusinessMashupsName = 'Business Mashups'
  PaginationNumber = 'Pagination Number'
  Modules = 'Modules'
  Environments = 'Environments'
  FileTypes = 'File Types'

  #_____________________________________________________________________
  # validations.
  validates_presence_of :name, :config_values
  validates_length_of :name, :in => 3..50,
    :too_short  => "More than {{count}} characters if you don't mind.",
    :too_long => "Less than {{count}} characters if you don't mind."
  validates_uniqueness_of :name
  validates_as_url :config_values, :if => :business_mashups?
  validates_numericality_of :config_values, :only_integer => true, :greater_than => 4, :less_than => 51, :if => :pagination_number?
  validates_length_of_csv_values :config_values, :in => 3..25, :if => :modules?
  validates_length_of_csv_values :config_values, :in => 1..25, :if => :environments?
  validates_length_of_csv_values :config_values, :in => 1..25, :if => :file_types?

  # After Save callback.
  after_save    :reset_cache
  after_destroy :reset_cache

  #_____________________________________________________________________
  # public class methods

  class << self
    # Searchs into the configurations table for all issues that match the
    # search string.
    def search(search, by = "name")
      if search
        find(:all, :conditions => ["#{by} like ?", "%#{search}%"], :order => :name)
      else
        find(:all, :order => :name)
      end
    end

    # Returns the cached list.
    # It is cached in YAML as it is better to serialize the object.
    def configs_cached(force=false)

      cached = Rails.cache.fetch('Configuration.configs', :force => force) do
        find(:all, :select => 'name, config_values').to_yaml
      end

      YAML::load(cached)
    end

    # Returns the business mashups data.
    def business_mashups(force=false)
      cached = Rails.cache.fetch('Configuration.business_mashups', :force => force) do
        find(:first,
            :select => 'name, config_values',
            :conditions => ["name like ?", BusinessMashupsName]).to_yaml
      end
      YAML::load(cached)
    end

    # Returns the pagination number data.
    def pagination_number(force=false)
      cached = Rails.cache.fetch('Configuration.pagination_number', :force => force) do
        find(:first,
            :select => 'name, config_values',
            :conditions => ["name like ?", PaginationNumber]).to_yaml
      end
      YAML::load(cached)
    end

    # Obtains the cached values again from configurations table.
    def reset_cache
      configs_cached(true)
      business_mashups(true)
      pagination_number(true)
    end
  end

  #_____________________________________________________________________
  # private methods
  private

  # Obtains the cached values again from configurations table.
  def reset_cache
    self.class.reset_cache
  end

  # Checks if the configuration name is for business mashups url.
  def business_mashups?
    name == BusinessMashupsName
  end

  # Checks if the configuration name is for pagination number.
  def pagination_number?
    name == PaginationNumber
  end

  # Checks if the configuration name is for modules.
  def modules?
    name == Modules
  end

  # Checks if the configuration name is for environments.
  def environments?
    name == Environments
  end

  # Checks if the configuration name is for FileTypes
  def file_types?
    name == FileTypes
  end
end
