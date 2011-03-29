# Put business logic of Unit Tests in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Unit Test Model class.
#
class UnitTest < ActiveRecord::Base

  #_____________________________________________________________________
  # Association.
  belongs_to :project

  #_____________________________________________________________________
  # validations
  # Max char lenghts:
  # :fsd_usecase_id => 11
  # :module => 200
  # :description => 1000
  # :result => 1000
  # :pass_brands => 200
  # :fail_brands => 200
  # :notes => 1000
  validates_presence_of :module, :description, :result, :project
  validate_at_least_one_of :pass_brands, :fail_brands
  validates_length_of :fsd_usecase_id, :maximum => 11, :allow_blank => true
  validates_length_of :module, :maximum => 200, :allow_blank => true
  validates_length_of :description, :maximum => 1000
  validates_length_of :result, :maximum => 1000
  validates_length_of :pass_brands, :maximum => 200
  validates_length_of :fail_brands, :maximum => 200
  validates_length_of :notes, :maximum => 1000, :allow_blank => true

  #_____________________________________________________________________
  # public methods

  # Let's define our to_html.
  def to_html
    m = Markaby::Builder.new({}, self)

    m.div do
      {
      :fsd_usecase_id => 'FSD UseCase ID:', :module => 'Module:',
      :description => 'Description:', :result => 'Result:',
      :brands => 'Brands:', :notes => 'Notes:'
      }.each do |key, value|
        h5 value
        span self.send(key).to_s
      end
    end
  end
end
