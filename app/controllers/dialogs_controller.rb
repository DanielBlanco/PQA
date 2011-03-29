# Put dialog control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Dialog's Controller class.
#
class DialogsController < ApplicationController

  skip_before_filter :get_project

  # This method will trap any call to this controller and try to render
  # the 'method name' action.
  def method_missing(m, *args)
    respond_to do |format|
      format.html { render :action => m }
    end
  end
  
  # This method will render the search form for walkthroughs.
  # It will render the page useing the 'search' layout.
  def walkthrough_search
  	@project = Project.find(params[:id])
  	render :layout => 'search'
  end
  
  # This method will render the search form for unit tests.
  # It will render the page useing the 'search' layout.
  def unit_test_search
  	@project = Project.find(params[:id])
  	render :layout => 'search'
  end
  
  # This method will render the search form for code reivews.
  # It will render the page useing the 'search' layout.
  def code_review_search
  	@project = Project.find(params[:id])
  	render :layout => 'search'
  end
  
  # This method will render the search form for performances.
  # It will render the page useing the 'search' layout.
  def performance_search
  	@project = Project.find(params[:id])
  	render :layout => 'search'
  end
  
  # This method will render the search form for projects.
  # It will render the page useing the 'search' layout.
  def project_search  	
  	render :layout => 'search'
  end
end
