#
# Put business logic of Code Reviews in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
#Code Review Model class.
class CodeReview < ActiveRecord::Base

  #_____________________________________________________________________
  # Association.
  belongs_to :project

  #_____________________________________________________________________
  # Validations.
  # Max char lenghts:
  # :line_number => 5
  # :module => 25
  # :description => 1000
  # :submitted_by => 50
  # :owner => 50
  # :ticket => 11
  validates_presence_of :description, :submitted_by, :owner, :project
  validates_length_of :module, :maximum => 25, :allow_blank => true
  validates_numericality_of :line_number,
    :only_integer => true,
    :allow_nil => true,
    :greater_than => 0,
    :less_than => 99999 # =o huge number for lines of code in a single file.
  validates_length_of :description, :maximum => 1000
  validates_length_of :submitted_by, :maximum => 50
  validates_length_of :owner, :maximum => 50
  validates_as_ticket_number :ticket, :allow_blank => true
  validates_inclusion_of :resolved, :in => [true, false]

  # Let's define our to_html.
  def to_html
    m = Markaby::Builder.new({}, self)

    m.div do
      {
      :module => 'Module:', :description => 'Description:',
      :line_number => 'Line Number:', :submitted_by => 'Submitted By:',
      :owner => 'Owner:', :ticket => 'Ticket:',
      :resolved => 'Resolved:'
      }.each do |key, value|
        h5 value
        span self.send(key).to_s
      end
    end
  end
end
