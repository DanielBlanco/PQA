# Put helper logic in here.
#
# Author::    Angel (mailto:amontenegro@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Methods added to this helper will be available to all templates in 
# the application.
#

module WriteExcelFileHelper
	require "spreadsheet/excel"	
	# Names and titles for each excel sheet
	WALKTHROUGH_NAME = "Walkthrough"
	WALKTHROUGH_TITLE = "Walkthroug's List"		
	MAIN_NAME = "Main"
	MAIN_TITLE = "Development Workbook"
	UNIT_TEST_NAME = "Unit Test"
	UNIT_TEST_TITLE = "Unit Test's List"
	CODE_REVIEW_NAME = "Code Review"
	CODE_REVIEW_TITLE = "Code Review's List"
	DEPLOYMENT_NAME = "Deployments"
	DEPLOYMENT_TITLE = "Deployment File List"
	PERFORMANCE_NAME = "Performance"
	PERFORMANCE_TITLE = "Performance's List"
	
	# Format's that will be applied for the different sheet's
	TITLE_FORMAT = Format.new(:bold => 600, :size => 16)
	TABLE_HEADER_FORMAT = Format.new(:bold => 600, :size => 12, :fg_color => 'black', :color => 'white')
	SUB_SECTION_FORMAT = Format.new(:fg_color => 'grey', :color => 'white')
	
	#-------------------------------------------------------------------
	# TODO Delete this method from here, we should add this in a "util" 
	# module, because it should be used here and also in the deployments 
	# page
	def new_section?(obj)

	if !@section
	  @section = {:action => obj.action}
	  return true
	end	

	if @section[:action] != obj.action
	  @section = {:action => obj.action}
	  return true
	end

	false
	end	
	#-------------------------------------------------------------------
	
	# This function is called by the project_controller to create the excel 
	# file, it will create the workbook and call to each method to create 
	# each sheet.
	# Require the name of the file (i.e. the path) and the project that will be written 
	# in a excel file
	def writeExcelFile(name, project)
		workbook = Spreadsheet::Excel.new(name)
		workbook.add_format(TITLE_FORMAT)
		workbook.add_format(TABLE_HEADER_FORMAT)			
  		workbook.add_format(SUB_SECTION_FORMAT)
  		writeMain(workbook, @project)
		writeWalkthrough(workbook, @project.walkthroughs)	
		writeUnitTest(workbook, @project.unit_tests)
		writeCodeReview(workbook, @project.code_reviews)
		writeDeployment(workbook, @project.deployments)
		writePerformance(workbook, @project.performances)
		workbook.close	
	end
	
	# This function will write the "Main" page in the "workbook" file
	def writeMain(workbook, project)
		worksheet = createSheet(workbook,MAIN_NAME,MAIN_TITLE)		
		worksheet.write(2,0, "Project")		
		worksheet.write(3,0, "Date")		
		worksheet.write(4,0, "Ticket #")						
		unless project.nil?
			worksheet.write(2,1, project.name)
			worksheet.write(3,1, project.started_on.to_s)
			worksheet.write(4,1, project.ticket)
		end
	end
	
	# This function will write the "Walkthrough" page in the "workbook" file
	def writeWalkthrough(workbook, walkthrough)
		worksheet = createSheet(workbook,WALKTHROUGH_NAME,WALKTHROUGH_TITLE)
		worksheet.write(2,0,"Issue ID",TABLE_HEADER_FORMAT)
		worksheet.write(2,1,"Description",TABLE_HEADER_FORMAT)
		worksheet.write(2,2,"URL",TABLE_HEADER_FORMAT)
		worksheet.write(2,3,"Severity",TABLE_HEADER_FORMAT)
		worksheet.write(2,4,"User",TABLE_HEADER_FORMAT)
		worksheet.write(2,5,"Owner",TABLE_HEADER_FORMAT)
		worksheet.write(2,6,"Resolved",TABLE_HEADER_FORMAT)
		
		row = 3
		column = 0
		unless walkthrough.nil?
			walkthrough.each do |wt|
				worksheet.write(row, column, wt.issue)				
				worksheet.write(row, column += 1, wt.description)
				worksheet.write(row, column += 1, wt.url)
				worksheet.write(row, column += 1, wt.severity)
				worksheet.write(row, column += 1, wt.user)
				worksheet.write(row, column += 1, wt.owner)
				worksheet.write(row, column += 1, wt.resolved.to_s)
				row += 1
				column = 0
			end
		end		
	end
	
	# This function will write the "Unit test" page in the "workbook" file
	def writeUnitTest(workbook, unit_test)
		worksheet = createSheet(workbook,UNIT_TEST_NAME,UNIT_TEST_TITLE)		
		worksheet.write(2,0,"FSD Use Case ID",TABLE_HEADER_FORMAT)
		worksheet.write(2,1,"Module",TABLE_HEADER_FORMAT)
		worksheet.write(2,2,"Description",TABLE_HEADER_FORMAT)
		worksheet.write(2,3,"Result",TABLE_HEADER_FORMAT)
		worksheet.write(2,4,"Pass Brands",TABLE_HEADER_FORMAT)
		worksheet.write(2,5,"Fail Brands",TABLE_HEADER_FORMAT)
		worksheet.write(2,6,"Notes",TABLE_HEADER_FORMAT)
		row = 3
		column = 0
		unless unit_test.nil?
			unit_test.each do |ut|
				worksheet.write(row, column, ut.fsd_usecase_id)
				worksheet.write(row, column += 1, ut.module)
				worksheet.write(row, column += 1, ut.description)
				worksheet.write(row, column += 1, ut.result)
				worksheet.write(row, column += 1, ut.pass_brands)
				worksheet.write(row, column += 1, ut.fail_brands)
				worksheet.write(row, column += 1, ut.notes)
				row += 1
				column = 0
			end
		end
	end
	
	# This function will write the "Code Review" page in the "workbook" file
	def writeCodeReview(workbook, code_review)
		worksheet = createSheet(workbook,CODE_REVIEW_NAME,CODE_REVIEW_TITLE)		
		worksheet.write(2,0,"Module",TABLE_HEADER_FORMAT)
		worksheet.write(2,1,"Line #",TABLE_HEADER_FORMAT)
		worksheet.write(2,2,"Description of problem",TABLE_HEADER_FORMAT)
		worksheet.write(2,3,"Submitted by",TABLE_HEADER_FORMAT)
		worksheet.write(2,4,"Owner",TABLE_HEADER_FORMAT)
		worksheet.write(2,5,"Ticket #",TABLE_HEADER_FORMAT)
		worksheet.write(2,6,"Resolved",TABLE_HEADER_FORMAT)
		
		row = 3
		column = 0
		unless code_review.nil?
			code_review.each do |cr|
				worksheet.write(row,column, cr.module.capitalize)
        		worksheet.write(row,column += 1, cr.line_number)
        		worksheet.write(row,column += 1, cr.description)
        		worksheet.write(row,column += 1, cr.submitted_by)
        		worksheet.write(row,column += 1, cr.owner)
        		worksheet.write(row,column += 1, cr.ticket)
        		worksheet.write(row,column += 1, cr.resolved.to_s)
        		row += 1
        		column = 0
			end		
		end
	end
	
	# This function will write the "Deployment" page in the "workbook" file
	# TODO This function should be refactored because similar code is used many times
	def writeDeployment(workbook, deployments)
		worksheet = createSheet(workbook,DEPLOYMENT_NAME,DEPLOYMENT_TITLE)
		worksheet.write(2,0,"Java, JSP and Configs",TABLE_HEADER_FORMAT)
		worksheet.write(3,0,"File Name/VSS Location",SUB_SECTION_FORMAT)
		worksheet.write(3,1,"File Type",SUB_SECTION_FORMAT)
		worksheet.write(3,2,"Action",SUB_SECTION_FORMAT)
		worksheet.write(3,3,"Env. Spec?",SUB_SECTION_FORMAT)
		
		column = 0
		row = 4
		deployments.search_in_common_section(nil).each do |d|
			worksheet.write(row, column, d.file)
			worksheet.write(row, column += 1, d.file_type)
			worksheet.write(row, column += 1, d.action)
			worksheet.write(row, column += 1, (d.environment_specific == 0 ? "NO" : "YES"))
			row += 1
			column = 0
		end
		
		row += 2
		worksheet.write(row,0,"The following files will be deleted",TABLE_HEADER_FORMAT)
		row += 1
		worksheet.write(row,0,"File Name",SUB_SECTION_FORMAT)
		worksheet.write(row,1,"File Type",SUB_SECTION_FORMAT)
		row += 1
		deployments.search_in_delete_section(nil).each do |d|
			worksheet.write(row,column, d.file)
			worksheet.write(row,column += 1, d.file_type)
			row += 1
			column = 0
		end
		
		row += 2
		worksheet.write(row,0,"Database changes",TABLE_HEADER_FORMAT)
		row += 1
		worksheet.write(row,0,"File Name",SUB_SECTION_FORMAT)
		worksheet.write(row,1,"File Type",SUB_SECTION_FORMAT)
		row += 1
		deployments.search_in_db_section(nil).each do |d|
			worksheet.write(row,column, d.file)
			worksheet.write(row,column += 1, d.file_type)
			row += 1
			column = 0
		end
		
		row += 2
		worksheet.write(row,0,"Technical Service tickets",TABLE_HEADER_FORMAT)
		row += 1
		worksheet.write(row,0,"File Name",SUB_SECTION_FORMAT)
		worksheet.write(row,1,"File Type",SUB_SECTION_FORMAT)
		row += 1
		deployments.search_in_ts_section(nil).each do |d|
			worksheet.write(row,column, d.file)
			worksheet.write(row,column += 1, d.file_type)
			row += 1
			column = 0
		end
		
		row += 2
		worksheet.write(row,0,"Batch Script files",TABLE_HEADER_FORMAT)
		row += 1
		worksheet.write(row,0,"File Name",SUB_SECTION_FORMAT)
		worksheet.write(row,1,"File Type",SUB_SECTION_FORMAT)
		row += 1
		deployments.search_in_bs_section(nil).each do |d|
			worksheet.write(row,column, d.file)
			worksheet.write(row,column += 1, d.file_type)
			row += 1
			column = 0
		end		
	end
	
	# This function will write the "Performance" page in the "workbook" file
	def writePerformance (workbook, performance)
		worksheet = createSheet(workbook,PERFORMANCE_NAME,PERFORMANCE_TITLE)
		worksheet.write(2,0,"Test description",TABLE_HEADER_FORMAT)
		worksheet.write(2,1,"URL/Component",TABLE_HEADER_FORMAT)
		worksheet.write(2,2,"Tester",TABLE_HEADER_FORMAT)
		worksheet.write(2,3,"Environment",TABLE_HEADER_FORMAT)
		worksheet.write(2,4,"Pass/Fail",TABLE_HEADER_FORMAT)
		worksheet.write(2,5,"Results/Comments",TABLE_HEADER_FORMAT)
		
		column = 0
		row = 3
		unless performance.nil?
			performance.each do |p|
				worksheet.write(row,column, p.description)
				worksheet.write(row,column += 1, p.url)
				worksheet.write(row,column += 1, p.tester)
				worksheet.write(row,column += 1, p.environment)
				worksheet.write(row,column += 1, p.pass ? "Pass":"Fail")
				worksheet.write(row,column += 1, p.result)
				row += 1
				column = 0
			end
		end		
	end
	
	# This function will create the workbook with the name 'name' and it
	# will put the title of the page 'title' in the cell (0,0)
	def createSheet(workbook, name, title)		
		worksheet = workbook.add_worksheet(name)
		worksheet.write(0,0, title, TITLE_FORMAT)
		return worksheet
	end		
  
end


