# Put Walkthroughs control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Walkthrough's Controller class.
#
class WalkthroughsController < ApplicationController

  # Runs before any action in the controller.
  before_filter :find_walkthrough, :only => [:show, :edit, :update, :destroy]

  # Index Action.
  # GET /projects/:id/walkthroughs
  # GET /projects/:id/walkthroughs.xml
  def index
    @walkthroughs = index_search
    flash_on_empty @walkthroughs

    @multi_objs = [@project.walkthroughs.new]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @walkthroughs }
      format.rss  # index.rss.builder
    end
  end

  # New Action.
  # GET /projects/:id/walkthroughs/new
  # GET /projects/:id/walkthroughs/new.xml
  def new
    @walkthrough = @project.walkthroughs.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @walkthrough }
    end
  end

  # Show Action.
  # GET /projects/:id/walkthroughs/:id
  # GET /projects/:id/walkthroughs/:id.xml
  def show
  end

  # Create Action
  # POST /projects/:id/walkthroughs
  # POST /projects/:id/walkthroughs.xml
  def create
    @walkthrough = @project.walkthroughs.new(params[:walkthrough])
    create_project_association @walkthrough, 'Walkthrough issue was successfully created.'
  end

  # Create action for multiple models.
  # POST /projects/:id/walkthroughs/multiple_create
  # POST /projects/:id/walkthroughs/multiple_create.xml
  def multiple_create

    return if nothing_to_save(params[:multi_objs], project_walkthroughs_url)

    @multi_objs = params[:multi_objs].collect { |obj| @project.walkthroughs.new(obj) }
    respond_to do |wants|
      if multi_save(@multi_objs)
        flash[:notice] = 'Walktroughs were successfully saved.'
        params[:page] = @project.walkthroughs.last_page
        wants.html { redirect_paginated_to(project_walkthroughs_url) }
        wants.xml  { render :xml => @multi_objs, :status => :created, :location => project_walkthroughs_url }
      else
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        wants.html {
          @walkthroughs = index_search
          render :index
        }
        wants.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update Action.
  # PUT /projects/:id/walkthroughs/1
  # PUT /projects/:id/walkthroughs/1.xml
  def update
    respond_to do |format|
      if @walkthrough.update_attributes(params[:walkthrough])
        flash[:notice] = 'Walkthrough issue was successfully updated.'
        format.html { redirect_to [@project, @walkthrough] }
        format.xml  { head :ok }
      else
        log_model_errors @walkthrough
        flash_model_errors @walkthrough
        format.html { render :action => "edit" }
        format.xml  { render :xml => @walkthrough.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Edit Action.
  # GET /projects/:id/walkthroughs/1/edit
  def edit
  end

  # Destroy Action.
  # DELETE /projects/:id/walkthroughs/1
  # DELETE /projects/:id/walkthroughs/1.xml
  def destroy
    @walkthrough.destroy

    respond_to do |format|
      flash[:notice] = 'Walkthrough issue deleted.'
      format.html { redirect_to project_walkthroughs_path }
      format.xml  { head :ok }
    end
  end

  # From here all functions are private.
  private

  # Find the walkthrough defined by param :id.
  def find_walkthrough
    @walkthrough = @project.walkthroughs.find(params[:id])
  rescue
    flash[:error] = "Walkthrough #{params[:id]} not found!"
    redirect_to project_walkthroughs_url(@project)
  end

  # Returns the list of walkthroughs for index page.
  def index_search
    @project.walkthroughs.search_paginated(params, params[:page])
  end
end
