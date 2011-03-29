require 'test_helper'

class CodeReviewTest < ActiveSupport::TestCase

  def setup
    @creview = CodeReview.new
    @creview.description = "Error in x module..."
    @creview.submitted_by = "dblanco"
    @creview.owner = "dblanco"
    @creview.resolved = false
    @creview.project = Project.find(:first)
  end

  # Testing module attribute.
  test "module attribute" do
    cr = @creview
    
    cr.module = nil
    assert cr.valid?, "Should be valid with nil module."
    
    cr.module = ''
    assert cr.valid?, "Should be valid with empty string module."

    200.times { cr.module += 'X' }
    assert cr.valid?, "Should be valid with #{cr.module.size} chars module."    
    
    cr.module += 'X'
    assert !cr.valid?, "Should NOT be valid with #{cr.module.size} chars module."
  end
  
  # Testing line_number attribute.
  test "line_number attribute" do
    cr = @creview
    
    cr.line_number = nil
    assert cr.valid?, "Should be valid with nil line number."
    
    cr.line_number = "X"
    assert !cr.valid?, "Should NOT be valid with string line number."

    cr.line_number = 0
    assert !cr.valid?, "Should NOT be valid with line number of 0."
    
    cr.line_number = -1
    assert !cr.valid?, "Should NOT be valid with a negative line number."
    
    cr.line_number = 1.1
    assert !cr.valid?, "Should NOT be valid with a float line number."
  end
  
  # Testing description attribute.
  test "description attribute" do
    cr = @creview
    
    cr.description = nil
    assert !cr.valid?, "Should NOT be valid with nil description."    
    
    cr.description = ""
    assert !cr.valid?, "Should NOT be valid with empty string description."    
    
    1000.times { cr.description += 'X' }
    assert cr.valid?, "Should be valid with #{cr.description.size} chars description."    
    
    cr.description += 'X'
    assert !cr.valid?, "Should NOT be valid with #{cr.description.size} chars description."
  end
  
  # Testing submitted_by attribute.
  test "submitted_by attribute" do
    cr = @creview
    
    cr.submitted_by = nil
    assert !cr.valid?, "Should NOT be valid with nil submitter."    
    
    cr.submitted_by = ""
    assert !cr.valid?, "Should NOT be valid with empty string submitter."    
    
    500.times { cr.submitted_by += 'X' }
    assert cr.valid?, "Should be valid with #{cr.submitted_by.size} chars submitter."    
    
    cr.submitted_by += 'X'
    assert !cr.valid?, "Should NOT be valid with #{cr.submitted_by.size} chars submitter."
  end
  
  # Testing owner attribute.
  test "owner attribute" do
    cr = @creview
    
    cr.owner = nil
    assert !cr.valid?, "Should NOT be valid with nil owner."    
    
    cr.owner = ""
    assert !cr.valid?, "Should NOT be valid with empty string owner."    
    
    100.times { cr.owner += 'X' }
    assert cr.valid?, "Should be valid with #{cr.owner.size} chars owner."    
    
    cr.owner += 'X'
    assert !cr.valid?, "Should NOT be valid with #{cr.owner.size} chars owner."
  end
  
  # Testing ticket attribute.
  test "ticket attribute" do
    cr = @creview
  	
    %w[ER-0041271 ER-0033666 XE-0033666 DBI-0033666].each do |ticket|
      cr.ticket = ticket
      assert cr.valid?, "Should be valid with good tickets."  	
    end
  	
    %w[ER-XXAS213 ER-003366 E1-0033666 33666 DBIA-0033666].each do |ticket|
      cr.ticket= ticket
      assert !cr.valid?, "Should NOT be valid with bad tickets."  	
    end

  end

  # Testing resolved attribute.
  test "resolved attribute" do
    cr = @creview
  	
    [nil, ''].each_with_index do |value, i|
      cr.resolved = value
      assert !cr.valid?, "Should NOT be valid with item #{i}."
    end
  	
    [false, true, 'false', 'true'].each_with_index do |value, i|
      cr.resolved = value
      assert cr.valid?, "Should be valid with item #{i}."
    end

  end
  
  # Testing minimum valid data for code review.
  test "should pass with valid data" do
    cr = @creview
    assert cr.save,  "Should be saved!"
  end  
end
