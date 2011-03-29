# Put performances control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Performance's Controller class.
#
class PerformancesController < ApplicationController

  # Runs before any action in the controller.
  before_filter :find_performance, :only => [:show, :edit, :update, :destroy]

  # Index Action.
  # GET /projects/:id/performances
  # GET /projects/:id/performances.xml
  def index

    @performances = index_search
    flash_on_empty @performances

    @multi_objs = [@project.performances.new]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @performances }
    end
  end

  # New Action.
  # GET /projects/:id/performances/new
  # GET /projects/:id/performances/new.xml
  def new
    @performance = @project.performances.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @performance }
    end
  end

  # Update Action.
  # GET /projects/:id/performances/1
  # GET /projects/:id/performances/1.xml
  def show
  end

  # Create Action
  # POST /projects/:id/performances
  # POST /projects/:id/performances.xml
  def create
    @performance = @project.performances.new(params[:performance])
    create_project_association @performance, 'Performance test was successfully created.'
  end

  # Create action for multiple models.
  # POST /projects/:id/unit_tests/multiple_create
  # POST /projects/:id/unit_tests/multiple_create.xml
  def multiple_create

    return if nothing_to_save(params[:multi_objs], project_performances_url)

    @multi_objs = params[:multi_objs].collect { |obj| @project.performances.new(obj) }
    respond_to do |wants|
      if multi_save(@multi_objs)
        flash[:notice] = 'Code Reviews were successfully saved.'
        params[:page] = @project.performances.last_page
        wants.html { redirect_paginated_to(project_performances_url) }
        wants.xml  { render :xml => @multi_objs, :status => :created, :location => project_performances_url }
      else
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        wants.html {
          @performances = index_search
          render :index
        }
        wants.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update Action.
  # PUT /projects/:id/performances/1
  # PUT /projects/:id/performances/1.xml
  def update
    respond_to do |format|
      if @performance.update_attributes(params[:performance])
        flash[:notice] = 'Performance test was successfully updated.'
        format.html { redirect_to [@project, @performance] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @performance.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Edit Action.
  # GET /projects/:id/performances/1/edit
  def edit
  end

  # Destroy Action.
  # DELETE /projects/:id/performances/1
  # DELETE /projects/:id/performances/1.xml
  def destroy
    @performance.destroy

    respond_to do |format|
      flash[:notice] = 'Performance test deleted.'
      format.html { redirect_to project_performances_url(@project) }
      format.xml  { head :ok }
    end
  end

  private

  # Find the performance test defined by param :id.
  def find_performance
    @performance = @project.performances.find(params[:id])
  rescue
    flash[:error] = "Performance #{params[:id]} not found!"
    redirect_to project_performances_url(@project)
  end

  # index search.
  def index_search
    @project.performances.search_paginated(params, params[:page])
  end
end
