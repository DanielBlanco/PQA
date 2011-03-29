require 'test_helper'

class DeploymentTest < ActiveSupport::TestCase

  def setup
    @deployment = Deployment.new
    @deployment.file = "$/.../.../xxx.java"
    @deployment.file_type = "JAVA"
    @deployment.environment_specific = false
    @deployment.action = "Edit"
    @deployment.ticket = "ER-0041271"
    @deployment.ticket_type = "Enhacement"
    @deployment.module = "Quick Remit"
    @deployment.project = Project.find(:first)
  end

  # Testing file attribute
  test "file attribute" do
    obj = @deployment
    
    obj.file = nil
    assert !obj.valid?, "Should NOT be valid with nil file."
    
    obj.file = ''
    assert !obj.valid?, "Should NOT be valid with empty string file."

    500.times { obj.file += 'X' }
    assert obj.valid?, "Should be valid with #{obj.file.size} chars file."    
    
    obj.file += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.file.size} chars file."
  end
  
  # Testing file_type attribute
  test "file_type attribute" do
    obj = @deployment
    
    obj.file_type = nil
    assert !obj.valid?, "Should NOT be valid with nil file_type."
    
    obj.file_type = ''
    assert !obj.valid?, "Should NOT be valid with empty string file_type."

    200.times { obj.file_type += 'X' }
    assert obj.valid?, "Should be valid with #{obj.file_type.size} chars file_type."    
    
    obj.file_type += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.file_type.size} chars file_type."
  end
  
  # Testing environment_specific attribute
  test "environment_specific attribute" do
    obj = @deployment
  	
    [nil, ''].each_with_index do |value, i|
      obj.environment_specific = value
      assert !obj.valid?, "Should NOT be valid with item #{i}."
    end
  	
    [false, true, 'false', 'true'].each_with_index do |value, i|
      obj.environment_specific = value
      assert obj.valid?, "Should be valid with item #{i}."
    end

  end
  
  # Testing action attribute
  test "action attribute" do
    obj = @deployment
    
    obj.action = nil
    assert !obj.valid?, "Should NOT be valid with nil action."
    
    obj.action = ''
    assert !obj.valid?, "Should NOT be valid with empty string action."

    20.times { obj.action += 'X' }
    assert obj.valid?, "Should be valid with #{obj.action.size} chars action."    
    
    obj.action += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.action.size} chars action."
  end
  
  # Testing ticket attribute
  test "ticket attribute" do
    obj = @deployment

    obj.ticket = nil
    assert !obj.valid?, "Should NOT be valid with nil tickets."  	
	
    obj.ticket = ''
    assert !obj.valid?, "Should NOT be valid empty string tickets."  	
  	
    %w[ER-0041271 ER-0033666 XE-0033666 DBI-0025979].each do |ticket|
      obj.ticket = ticket
      assert obj.valid?, "Should be valid with good tickets."  	
    end
  	
    %w[ER-XXAS213 ER-003366 E1-0033666 33666 SSXE-0033666].each do |ticket|
      obj.ticket= ticket
      assert !obj.valid?, "Should NOT be valid with bad tickets."  	
    end

  end
  # Testing ticket_type attribute
  test "ticket_type attribute" do
    obj = @deployment
    
    obj.ticket_type = nil
    assert !obj.valid?, "Should NOT be valid with nil ticket_type."
    
    obj.ticket_type = ''
    assert !obj.valid?, "Should NOT be valid with empty string ticket_type."

    200.times { obj.ticket_type += 'X' }
    assert obj.valid?, "Should be valid with #{obj.ticket_type.size} chars ticket_type."    
    
    obj.ticket_type += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.ticket_type.size} chars ticket_type."
  end
  
  # Testing minimum valid data for deployment.
  test "should pass with valid data" do
    obj = @deployment
    assert obj.save,  "Should be saved!"
  end  
end
