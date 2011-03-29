#
# Put business logic of Deployments in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Deployment Model class.
#
# TODO: What about SBI's?
class Deployment < ActiveRecord::Base

  #_____________________________________________________________________
  # Associations.
  belongs_to :project

  before_save :check_environment_files

  #_____________________________________________________________________
  # Validations.
  # Max char lenghts:
  # :file => 500
  # :file_type => 50
  # :action => 20
  validates_presence_of :file, :file_type, :action
  validates_length_of :file, :maximum => 500
  validates_as_vss_file :file
  validates_length_of :file_type, :maximum => 50
  validates_length_of :action, :maximum => 20
  validates_inclusion_of :section, :in => %w[DB TS BS SBI Delete], :allow_blank => true
  validates_uniqueness_of :file, :scope => [:section], :message => '^You cannot add the same file more than once.'

  #_____________________________________________________________________
  # public class methods

  class << self
    # Searchs the deployments based on a project and a search parameter.
    def search(search, options={})
      options.symbolize_keys!
      options[:by] ||= 'file'
      options[:select] ||= '*'
      options[:order] ||= 'action, file_type'
      if search
        options[:conditions] ||= ["#{options[:by]} like ?", "%#{search}%"]
        find(:all, :select => options[:select],
          :conditions => options[:conditions],
          :order => options[:order])
      else
        options[:conditions] ||= []
        find(:all, :select => options[:select],
          :conditions => options[:conditions],
          :order => options[:order])
      end
    end

    # Searchs all files and modules
    def find_all_files_and_modules(search, by="file")
      search(search, {:by => '', :select => 'DISTINCT file', :order => 'file'})
    end

    # Returns the list of files in one section.
    def search_by_section(search, section, options={})
      options[:by] ||= 'file'
      section_condition = section.nil? ? 'section IS ?' : 'section = ?'
      options[:conditions] = ["#{options[:by]} like ? AND #{section_condition}", "%#{search}%", section]
      search(search, options)
    end

    # This piece of code creates a method for each available section.
    %w[Common DB TS BS SBI Delete].each do |s|
      define_method "search_in_#{s.downcase}_section" do |*args|
        search = args.first || ''
        options = args.second || {}
        s = '' if s == 'Common'
        search_by_section(search, s, options)
      end
    end

  end
  #_____________________________________________________________________
  # public methods

  # Checks if we are on Delete section.
  def delete_section?
    section == 'Delete'
  end

  # Checks if we are on DB section.BS SBI
  def db_section?
    section == 'DB'
  end

  # Checks if we are on TS section.BS SBI
  def ts_section?
    section == 'TS'
  end

  # Checks if we are on BS section.
  def bs_section?
    section == 'BS'
  end

  # Checks if we are on SBI section.
  def sbi_section?
    section == 'SBI'
  end

  #_____________________________________________________________________
  # private methods
  private

  # This method checks if the file attribute is environment specific or
  # not.
  def check_environment_files
    self.environment_specific = Envspecific.enviroment_specific?(file)
    true
  end
end
