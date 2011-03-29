# Put Unit test control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Unit Test's Controller class.
#
class UnitTestsController < ApplicationController

  # Runs before any action in the controller.
  before_filter :find_unit_test, :only => [:show, :edit, :update, :destroy]

  # Index Action.
  # GET /projects/:id/unit_tests
  # GET /projects/:id/unit_tests.xml
  def index
    @utests = index_search
    flash_on_empty @utests

    @multi_objs = [@project.unit_tests.new]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @utests }
      format.rss  # index.rss.builder
    end
  end

  # New Action.
  # GET /projects/:id/unit_tests/1
  # GET /projects/:id/unit_tests/1.xml
  def show
  end

  # New Action.
  # GET /projects/:id/unit_tests/new
  # GET /projects/:id/unit_tests/new.xml
  def new
    @utest = @project.unit_tests.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @utest }
    end
  end

  # Update Action.
  # PUT /projects/:id/unit_tests/1
  # PUT /projects/:id/unit_tests/1.xml
  def update
    respond_to do |format|
      if @utest.update_attributes(params[:unit_test])
        flash[:notice] = 'Unit test was successfully updated.'
        format.html { redirect_to [@project, @utest] }
        format.xml  { head :ok }
      else
        logger.error @utest.errors.full_messages.join('; ')
        flash[:error] = 'Error updating unit test: ' + view_model_errors(@utest)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @utest.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Edit Action.
  # GET /projects/:id/unit_tests/1/edit
  def edit
  end

  # Create Action
  # POST /projects/:id/unit_tests
  # POST /projects/:id/unit_tests.xml
  def create
    @utest = @project.unit_tests.new(params[:unit_test])
    create_project_association @utest, 'Unit test was successfully created.'
  end

  # Create action for multiple models.
  # POST /projects/:id/unit_tests/multiple_create
  # POST /projects/:id/unit_tests/multiple_create.xml
  def multiple_create

    return if nothing_to_save(params[:multi_objs], project_unit_tests_url)

    @multi_objs = params[:multi_objs].collect { |obj| @project.unit_tests.new(obj) }
    respond_to do |wants|
      if multi_save(@multi_objs)
        flash[:notice] = 'Unit Tests were successfully saved.'
        params[:page] = @project.unit_tests.last_page
        wants.html { redirect_paginated_to(project_unit_tests_url) }
        wants.xml  { render :xml => @multi_objs, :status => :created, :location => project_unit_tests_url }
      else
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        wants.html {
          @utests = index_search
          render :index
        }
        wants.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Destroy Action.
  # DELETE /projects/:id/unit_tests/1
  # DELETE /projects/:id/unit_tests/1.xml
  def destroy
    @utest.destroy

    respond_to do |format|
      flash[:notice] = 'Unit Test deleted.'
      format.html { redirect_to project_unit_tests_url(@project) }
      format.xml  { head :ok }
    end
  end


  # From here all functions are private.
  private

  # Find the unit test defined by param :id.
  def find_unit_test
    @utest = @project.unit_tests.find(params[:id])
  rescue
    flash[:error] = "Unit test #{params[:id]} not found!"
    redirect_to project_unit_tests_url(@project)
  end

  def index_search
    @project.unit_tests.search_paginated(params, params[:page])
  end
end
