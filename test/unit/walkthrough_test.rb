require 'test_helper'

#
# Put Walkthrough tests in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Walkthrough's Test class.
#
class WalkthroughTest < ActiveSupport::TestCase

  def setup
    @walktrhough = Walkthrough.new
    @walktrhough.issue = "ER-0041271"
    @walktrhough.user = "tsysadm/password/columbus"
    @walktrhough.owner = "dblanco"
    @walktrhough.description = "Error in x module..."
    @walktrhough.severity = 0
    @walktrhough.project = Project.find(:first)
  end

  #
  test "testing issue attribute" do
    wt = @walktrhough
  	
    %w[ER-0041271 ER-0033666 XE-0033666 DBI-0056877].each do |issue|
      wt.issue = issue
      assert wt.valid?, "Walkthrough NOT valid with good issue data."  	
    end
  	
    %w[ER-XXAS213 ER-003366 E1-0033666 33666 ADBI-0056877].each do |issue|
      wt.issue = issue
      assert !wt.valid?, "Walkthrough IS valid with bad issue data."  	
    end

  end

  #
  test "testing description attribute" do
    wt = @walktrhough
    wt.description = "Error in X module..."
    assert wt.valid?,  "Description is NOT valid with good data"
  	
    wt.description = ""
    assert !wt.valid?,  "Description IS valid with bad data"
  	
    wt.description = nil
    assert !wt.valid?,  "Description IS valid with bad data"
  	
    wt.description = ""
    1000.times { wt.description += "X" }
    assert wt.valid?,  "Description is NOT valid with 1000 characters"

    wt.description = ""
    1001.times { wt.description += "X" }
    assert !wt.valid?,  "Description IS valid with 1001 characters"
  	
  end
  
  #
  test "testing url attribute" do
    wt = @walktrhough
  	
    wt.url = ""
    assert wt.valid?,  "URL is NOT valid with empty string"
  	
    wt.url = nil
    assert wt.valid?,  "URL is NOT valid with nil string"
  	
    wt.url = ""
    500.times { wt.url += "X" }
    assert wt.valid?,  "URL is NOT valid with 500 characters"

    wt.url = ""
    501.times { wt.url += "X" }
    assert !wt.valid?,  "URL IS valid with 501 characters"
  	
  end

  # 
  test "testing severity attribute" do
  
    wt = @walktrhough
    (0..3).each do |severity|
      wt.severity = severity
      assert wt.valid?, "Severity is NOT valid with a value of #{severity}."
    end

    wt.severity = nil
    assert !wt.valid?, "Severity IS valid with a nil value."

    wt.severity = 4
    assert !wt.valid?, "Severity IS valid with a value greater than 3."
  	
    wt.severity = -1
    assert !wt.valid?, "Severity IS valid with a value lower than 0."
  end
  
  #
  test "testing user attribute" do
    wt = @walktrhough
    wt.user = ""
    assert !wt.valid?, "User IS valid with empty string."
  	
    wt.user = nil
    assert !wt.valid?, "User IS valid with nil string."

    wt.user = ""
    1000.times { wt.user += "X" }
    assert wt.valid?,  "User is NOT valid with 1000 characters"
  	
    wt.user = ""
    1001.times { wt.user += "X" }
    assert !wt.valid?,  "User IS valid with 1001 characters"
  end
  
  #
  test "testing owner attribute" do
    wt = @walktrhough
  	
    wt.owner = ""
    assert !wt.valid?,  "Owner IS valid with empty string"
  	
    wt.owner = nil
    assert !wt.valid?,  "Owner IS valid with nil string"
  	
    wt.owner = ""
    100.times { wt.owner += "X" }
    assert wt.valid?,  "Owner is NOT valid with #{wt.owner.size} characters"

    wt.owner += "X"
    assert !wt.valid?,  "Owner IS valid with #{wt.owner.size} characters"
  	
  end

  #
  test "should pass with valid data" do
    wt = @walktrhough
    assert wt.valid?,  "Walkthrough is NOT valid!"
  end  
end
