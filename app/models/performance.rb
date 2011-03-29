#
# Put business logic of Performances in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Performance Model class.
#
class Performance < ActiveRecord::Base

  #_____________________________________________________________________
  # Association.
  belongs_to :project

  #_____________________________________________________________________
  # Validations.
  # Max char lenghts:
  # :tester => 50
  # :url => 500
  # :description => 1000
  # :environment => 25
  # :result => 1000
  validates_presence_of :description, :tester, :environment, :result
  validates_length_of :description, :maximum => 1000
  validates_length_of :url, :maximum => 500, :allow_blank => true
  validates_length_of :tester, :maximum => 50
  validates_length_of :environment, :maximum => 25
  validates_inclusion_of :pass, :in => [true, false]
  validates_length_of :result, :maximum => 1000

end
