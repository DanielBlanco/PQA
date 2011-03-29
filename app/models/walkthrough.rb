# Put business logic of Walkthrough in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Walkthrough Model class.
#
class Walkthrough < ActiveRecord::Base

  # Association.
  belongs_to :project

  # Validations.
  # Max char lenghts:
  # :issue => 11
  # :description => 1000
  # :url => 500
  # :severity => 1
  # :owner => 50
  # :user => 500
  validates_presence_of :description, :owner, :user, :project
  validates_length_of :description, :maximum => 1000
  validates_as_ticket_number :issue, :allow_blank => true
  validates_length_of :owner, :maximum => 50
  validates_numericality_of :severity, :only_integer => true, :message => 'can only be whole number.'
  validates_inclusion_of :severity, :in => 0..3, :message => 'can only be between 0 and 3.'
  validates_length_of :url, :maximum => 500, :allow_blank => true
  validates_length_of :user, :maximum => 500

  # Let's define our to_html.
  def to_html
    m = Markaby::Builder.new({}, self)

    m.div do
      {
      :issue => 'Issue ID:', :description => 'Description:',
      :owner => 'Owner:', :severity => 'Severity:',
      :url => 'URL:', :user => 'User:',
      :resolved => 'Resolved:'
      }.each do |key, value|
        h5 value
        span self.send(key).to_s
      end
    end
  end
end
