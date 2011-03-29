# Put Deployments control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Deployment's Controller class.
#
class DeploymentsController < ApplicationController

  # Runs before any action in the controller.
  before_filter :find_deployment, :only => [:show, :edit, :update, :destroy]

  #_____________________________________________________________________
  # public methods

  # Index Action.
  # GET /projects/:id/deployments
  # GET /projects/:id/deployments.xml
  def index
    @deployments = deployment.search_in_common_section(params[:search_file])

    index_respond
  end

  # Kind of Index Action.
  # GET /projects/:id/deployments/delete_section
  # GET /projects/:id/deployments/delete_section.xml
  def delete_section
    @deployments = deployment.search_in_delete_section(params[:search_file])
    index_respond
  end

  # Kind of Index Action.
  # GET /projects/:id/deployments/db_section
  # GET /projects/:id/deployments/db_section.xml
  def db_section
    @deployments = deployment.search_in_db_section(params[:search_file])
    index_respond
  end

  # Kind of Index Action.
  # GET /projects/:id/deployments/ts_section
  # GET /projects/:id/deployments/ts_section.xml
  def ts_section
    @deployments = deployment.search_in_ts_section(params[:search_file])
    index_respond
  end

  # Kind of Index Action.
  # GET /projects/:id/deployments/bs_section
  # GET /projects/:id/deployments/bs_section.xml
  def bs_section
    @deployments = deployment.search_in_bs_section(params[:search_file])
    index_respond
  end

  # Kind of Index Action.
  # GET /projects/:id/deployments/sbi_section
  # GET /projects/:id/deployments/sbi_section.xml
  def sbi_section
    render :text => 'Not Implemented'
  end

  # Create Action
  # POST /projects/:id/deployments
  # POST /projects/:id/deployments.xml
  def create
    respond_url = project_deployments_url(@project)

    multiple_create(:index, respond_url) do
      @deployments = deployment.search_in_common_section(params[:search])
    end
  end

  # Create Action
  # POST /projects/:id/create_delete_section
  # POST /projects/:id/create_delete_section.xml
  def create_delete_section
    respond_url = delete_section_project_deployments_url(@project)

    multiple_create(:delete_section, respond_url) do
      @deployments = deployment.search_in_delete_section(params[:search])
    end
  end

  # Create Action
  # POST /projects/:id/create_db_section
  # POST /projects/:id/create_db_section.xml
  def create_db_section
    respond_url = db_section_project_deployments_url(@project)

    multiple_create(:db_section, respond_url) do
      @deployments = deployment.search_in_db_section(params[:search])
    end
  end

  # Create Action
  # POST /projects/:id/create_ts_section
  # POST /projects/:id/create_ts_section.xml
  def create_ts_section
    respond_url = ts_section_project_deployments_url(@project)

    multiple_create(:ts_section, respond_url) do
      @deployments = deployment.search_in_ts_section(params[:search])
    end
  end

  # Create Action
  # POST /projects/:id/create_bs_section
  # POST /projects/:id/create_bs_section.xml
  def create_bs_section
    respond_url = bs_section_project_deployments_url(@project)

    multiple_create(:bs_section, respond_url) do
      @deployments = deployment.search_in_bs_section(params[:search])
    end
  end

  # Update Action.
  # GET /projects/:id/deployments/1
  # GET /projects/:id/deployments/1.xml
  def show
  end


  # Update Action.
  # PUT /projects/:id/deployments/1
  # PUT /projects/:id/deployments/1.xml
  def update
    respond_to do |format|
      if @deployment.update_attributes(params[:deployment])
        flash[:notice] = 'Deployment entry was successfully updated.'
        format.html { redirect_to [@project, @deployment] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @deployment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Edit Action.
  # GET /projects/:id/deployments/1/edit
  def edit
  end

  # Destroy Action.
  # DELETE /projects/:id/deployments/1
  # DELETE /projects/:id/deployments/1.xml
  def destroy

    url = index_section_url

    @deployment.destroy

    respond_to do |format|
      flash[:notice] = 'Deployment entry deleted.'
      format.html { redirect_to url }
      format.xml  { head :ok }
    end
  end

  #_____________________________________________________________________
  # private methods
  private

  # Find the deployment entry defined by param :id.
  def find_deployment
    @deployment = deployment.find(params[:id])
  rescue
    flash[:error] = "Deployment #{params[:id]} not found!"
    redirect_to project_deployments_url(@project)
  end

  # Common respond for all index definitions.
  def index_respond
    @multi_objs = [deployment.new]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deployments }
    end
  end

  # Multiple Create
  def multiple_create(section, respond_url, &block)

    return if nothing_to_save(params[:multi_objs], respond_url)

    @multi_objs = params[:multi_objs].collect { |obj| deployment.new(obj) }

    respond_to do |format|
      if multi_save(@multi_objs)
        flash[:notice] = 'Files were successfully saved.'
        params[:page] = deployment.last_page
        format.html { redirect_paginated_to(respond_url) }
        format.xml  { render :xml => @multi_objs, :status => :created, :location => respond_url }
      else
        yield # Calling the block...
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        format.html { render section }
        format.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Returns @project.deployments objects.
  def deployment
    @project.deployments
  end

  # Returns the index url based on deployment section.
  def index_section_url
    if @deployment.delete_section?
      delete_section_project_deployments_url(@project)
    elsif @deployment.db_section?
      db_section_project_deployments_url(@project)
    elsif @deployment.ts_section?
      ts_section_project_deployments_url(@project)
    elsif @deployment.bs_section?
      bs_section_project_deployments_url(@project)
    else
      project_deployments_url(@project)
    end
  end
end
