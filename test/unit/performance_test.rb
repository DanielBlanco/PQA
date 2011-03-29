require 'test_helper'

class PerformanceTest < ActiveSupport::TestCase

  def setup
  	@performance = Performance.new
  	@performance.description = "Testing server response time"
  	@performance.tester = "dblanco"
  	@performance.environment = "Development"
  	@performance.pass = false
  	@performance.results = "Good performance times..."
  	@performance.project = Project.find(:first)
  end
  
  # Testing description attribute.
  test "description attribute" do
    obj = @performance
    
    obj.description = nil
    assert !obj.valid?, "Should NOT be valid with nil description."
    
    obj.description = ''
    assert !obj.valid?, "Should NOT be valid with empty string description."

    5000.times { obj.description += 'X' }
    assert obj.valid?, "Should be valid with #{obj.description.size} chars description."    
    
    obj.description += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.description.size} chars description."
  end
  
  # Testing url attribute.
  test "url attribute" do
    obj = @performance
    
    obj.url = nil
    assert obj.valid?, "Should be valid with nil url."
    
    obj.url = ''
    assert obj.valid?, "Should be valid with empty string url."

    500.times { obj.url += 'X' }
    assert obj.valid?, "Should be valid with #{obj.url.size} chars url."    
    
    obj.url += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.url.size} chars url."
  end
  
  # Testing tester attribute.
  test "tester attribute" do
    obj = @performance
    
    obj.tester = nil
    assert !obj.valid?, "Should NOT be valid with nil tester."
    
    obj.tester = ''
    assert !obj.valid?, "Should NOT be valid with empty string tester."

    200.times { obj.tester += 'X' }
    assert obj.valid?, "Should be valid with #{obj.tester.size} chars tester."    
    
    obj.tester += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.tester.size} chars tester."
  end
  
  # Testing environment attribute.
  test "environment attribute" do
    obj = @performance
    
    obj.environment = nil
    assert !obj.valid?, "Should NOT be valid with nil environment."
    
    obj.environment = ''
    assert !obj.valid?, "Should NOT be valid with empty string environment."

    1000.times { obj.environment += 'X' }
    assert obj.valid?, "Should be valid with #{obj.environment.size} chars environment."    
    
    obj.environment += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.environment.size} chars environment."
  end
  
  # Testing pass attribute.
  test "pass attribute" do
  	obj = @performance
  	
  	[nil, ''].each_with_index do |value, i|
  		obj.pass = value
  		assert !obj.valid?, "Should NOT be valid with item #{i}."
  	end
  	
  	[false, true, 'false', 'true'].each_with_index do |value, i|
  		obj.pass = value
  		assert obj.valid?, "Should be valid with item #{i}."
  	end

  end
  
  # Testing results attribute.
  test "results attribute" do
    obj = @performance
    
    obj.results = nil
    assert !obj.valid?, "Should NOT be valid with nil results."
    
    obj.results = ''
    assert !obj.valid?, "Should NOT be valid with empty string results."

    5000.times { obj.results += 'X' }
    assert obj.valid?, "Should be valid with #{obj.results.size} chars results."    
    
    obj.results += 'X'
    assert !obj.valid?, "Should NOT be valid with #{obj.results.size} chars results."
  end
  
  # Testing minimum valid data for performance.
  test "should pass with valid data" do
  	obj = @performance
  	assert obj.save,  "Should be saved!"
  end    
end
