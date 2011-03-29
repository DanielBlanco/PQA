#
# Put business logic of Deployments in here.
#
# Author::    Eugenia (mailto:earguedas@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Deployment Model class.
#
# TODO: What about SBI's?
class Envspecific < ActiveRecord::Base

  #Validations
  validates_presence_of :file
  validates_uniqueness_of :file

  after_save    :reset_cache
  after_destroy :reset_cache

  #_____________________________________________________________________
  # public class methods
  class << self

    # Returns true if the given file is an environment specific file,
    # false otherwise.
    def enviroment_specific?(file)
      envspecific_regexs.each do |env_spec|
        #logger.info 'File: ' + env_spec
        return true if file.match(env_spec)
      end
      false
    end

    # Returns the list of environment specific files in regex.
    # If the list is in cache that list is returned, if it is not it is
    # returned from database.
    # ===Usage
    # * envspecific_regexs #=> Returns the list from cache.
    # * envspecific_regexs(false) #=> Returns the list from cache.
    # * envspecific_regexs(true) #=> Returns the list from db.
    def envspecific_regexs(force=false)
      Rails.cache.fetch('Envspecific.reg_exps', :force => force) do
        caching = []
        all.each do |env_spec|
          env_file = '\A' + env_spec.file + '\Z'
          env_file.gsub!('/', '\/')
          env_file.gsub!('$', '\$')
          env_file.gsub!('.', '\.')
          env_file.gsub!('*', '(.)*')
          caching << env_file
        end
        caching
      end
    end

    # Obtains the cached values again from configurations table.
    def reset_cache
      envspecific_regexs(true)
    end
  end

  #_____________________________________________________________________
  # private methods
  private

  # Obtains the cached values again from Envspecifics table.
  def reset_cache
    self.class.reset_cache
  end

end
