require 'test_helper'
#
# Put Project tests in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Project's Test class.
#
class ProjectTest < ActiveSupport::TestCase

  def setup
    @project = Project.new
    # Default name is "Untitled!"
    @project.name = "TSYS Development project"
  end


  #
  test "should return true with valid data" do
    p = @project
    assert p.valid?,  "Project is NOT valid!"
  end

  # 
  test "should return false and add errors with empty project" do
    project = Project.new
    project.name = nil
    assert !project.valid?, "Project IS valid without a name."
  	
    project.name = ""
    assert !project.valid?, "Project IS valid without a name."
  	
    project.name = "1234"
    assert !project.valid?, "Project IS valid with a name of 4 chars."
  	
    project.name = "12345"
    assert project.valid?, "Project is NOT valid with a name of 5 chars."
  end
  
  # Testing ttrack attribute
  test "ttrack attribute" do
    p = @project
        
    %w[ER-0041271 ER-0033666 XE-0033666 DBI-0033666].each do |ticket|
      p.ttrack = ticket
      assert p.valid?, "Should be valid with good tickets."  	
    end
    
    %w[ER-XXAS213 ER-003366 E1-0033666 33666 DBIA-0033666].each do |ticket|
      p.ttrack = ticket
      assert !p.valid?, "Should NOT be valid with bad tickets."  	
    end

  end  

end
