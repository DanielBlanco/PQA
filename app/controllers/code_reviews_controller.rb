# Put CodeReview control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# CodeReview's Controller class.
#
class CodeReviewsController < ApplicationController

  # Runs before any action in the controller.
  before_filter :find_code_review, :only => [:show, :edit, :update, :destroy]

  # Index Action.
  # GET /projects/:id/code_reviews
  # GET /projects/:id/code_reviews.xml
  def index
    @code_reviews = index_search
    flash_on_empty @code_reviews

    @multi_objs = [@project.code_reviews.new]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @code_reviews }
      format.rss  # index.rss.builder
    end
  end

  # New Action.
  # GET /projects/:id/code_reviews/new
  # GET /projects/:id/code_reviews/new.xml
  def new
    @code_review = @project.code_reviews.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @code_review }
    end
  end

  # Update Action.
  # GET /projects/:id/code_reviews/1
  # GET /projects/:id/code_reviews/1.xml
  def show
  end

  # Create Action
  # POST /projects/:id/code_reviews
  # POST /projects/:id/code_reviews.xml
  def create
    @code_review = @project.code_reviews.new(params[:code_review])
    create_project_association @code_review, 'Code review issue was successfully created.'
  end

  # Create action for multiple models.
  # POST /projects/:id/unit_tests/multiple_create
  # POST /projects/:id/unit_tests/multiple_create.xml
  def multiple_create

    return if nothing_to_save(params[:multi_objs], project_code_reviews_url)

    @multi_objs = params[:multi_objs].collect { |obj| @project.code_reviews.new(obj) }
    respond_to do |wants|
      if multi_save(@multi_objs)
        params[:page] = @project.code_reviews.last_page
        flash[:notice] = 'Code Reviews were successfully saved.'
        wants.html { redirect_paginated_to(project_code_reviews_url) }
        wants.xml  { render :xml => @multi_objs, :status => :created, :location => project_code_reviews_url }
      else
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        wants.html {
          @code_reviews = index_search
          render :index
        }
        wants.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Update Action.
  # PUT /projects/:id/code_reviews/1
  # PUT /projects/:id/code_reviews/1.xml
  def update
    respond_to do |format|
      if @code_review.update_attributes(params[:code_review])
        flash[:notice] = 'Code review issue was successfully updated.'
        format.html { redirect_to [@project, @code_review] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @code_review.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Edit Action.
  # GET /projects/:id/code_reviews/1/edit
  def edit
  end

  # Destroy Action.
  # DELETE /projects/:id/code_reviews/1
  # DELETE /projects/:id/code_reviews/1.xml
  def destroy
    @code_review.destroy

    respond_to do |format|
      flash[:notice] = 'Code Review issue deleted.'
      format.html { redirect_to project_code_reviews_url(@project) }
      format.xml  { head :ok }
    end
  end

  private

  # Find the code review issue defined by param :id.
  def find_code_review
    @code_review = @project.code_reviews.find(params[:id])
  rescue
    flash[:error] = "Code Review #{params[:id]} not found!"
    redirect_to project_code_reviews_url(@project)
  end

  # Search performed when the index action is accessed.
  def index_search
    @project.code_reviews.search_paginated(params, params[:page])
  end
end
