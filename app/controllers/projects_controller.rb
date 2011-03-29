# Put Projects control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Project's Controller class.
#
class ProjectsController < ApplicationController
  #Library used to write excel files
  #require "spreadsheet/excel"
  #Helper used to write in the excel files
  include WriteExcelFileHelper

  skip_before_filter :get_project

  #The path where the files will be downloaded
  DOWNLOAD_PATH = "#{RAILS_ROOT}/public/downloads/"

  # Runs before any action in the controller.
  before_filter :find_project, :only => [:show, :open, :edit, :update, :destroy, :export, :create_excel]

  # Redirects the user to the correct project.
  def redirect
    ticket  = params[:path].first
    project = Project.find(:first, :conditions => ['ticket LIKE ?', "%#{ticket}%"])
    if project
      redirect_to project_path(project)
    else
      flash[:notice] = "Oops! No project matched your ticket criteria"
      redirect_to projects_path
    end
  end

  # Index Action.
  # GET /projects
  # GET /projects.xml
  def index
    @projects = Project.search_paginated(params, params[:page])
    @project = Project.new

    flash_on_empty @projects
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => Project.all }
    end
  end

  # Show Action.
  # GET /projects/1
  # GET /projects/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # New Action.
  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # Edit Action.
  # GET /projects/1/edit
  def edit
  end

  # Create Action
  # POST /projects
  # POST /projects.xml
  def create
      @project = Project.new(params[:project])
      @projects = Project.search(params)

      respond_to do |format|
        if @project.save
          flash[:notice] = 'Project was successfully created.'
          format.html { redirect_to projects_url }
          format.xml  { render :xml => @project, :status => :created, :location => @project }
        else
          format.html { render :action => "index" }
          format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
        end
        format.js
      end
  end

  # Update Action.
  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        logger.error @project.errors.full_messages.join('; ')
        flash[:error] = 'Error updating project.'
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Destroy Action.
  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project.destroy

    respond_to do |format|
      flash[:notice] = 'Project deleted.'
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end

  # Show the page to select the download type
  def export
  	respond_to do |format|
      format.html # export.html.erb
    end
  end

  # Write the excel file in the DOWNLOAD_PATH path and show a dialog box
  # that allow the user to download the file to his machine
  # /GET /create_excel
  def create_excel
    name = DOWNLOAD_PATH + @project.name + ".xls"
  	writeExcelFile(name, @project)
    send_file name, :type=>"application/excel"
  end

  # From here all functions are private.
  private

  # Find the post defined by param :id.
  def find_project
    @project = Project.find(params[:id])
  rescue
    flash[:error] = "Project #{params[:id]} not found!"
    redirect_to projects_url(@project)
  end
end
