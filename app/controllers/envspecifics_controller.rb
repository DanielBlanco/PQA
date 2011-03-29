class EnvspecificsController < ApplicationController

  skip_before_filter :get_project

  # GET /envspecifics
  # GET /envspecifics.xml
  def index
    @envspecifics = Envspecific.search_paginated(params, params[:page])
    flash_on_empty @envspecifics

    @multi_objs = [Envspecific.new]
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @envspecifics }
    end
  end

  # GET /envspecifics/1
  # GET /envspecifics/1.xml
  def show
    @envspecific = Envspecific.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @envspecific }
    end
  end

  # GET /envspecifics/new
  # GET /envspecifics/new.xml
  def new
    @envspecific = Envspecific.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @envspecific }
    end
  end

  # GET /envspecifics/1/edit
  def edit
    @envspecific = Envspecific.find(params[:id])
  end

  # POST /envspecifics
  # POST /envspecifics.xml
  def create
    @envspecific = Envspecific.new(params[:envspecific])

    respond_to do |format|
      if @envspecific.save
        flash[:notice] = 'Envspecific was successfully created.'
        format.html { redirect_to(envspecifics_path) }
        format.xml  { render :xml => @envspecific, :status => :created, :location => @envspecific }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @envspecific.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Create action for multiple models.
  # POST /projects/:id/envspecifics/multiple_create
  # POST /projects/:id/envspecifics/multiple_create.xml
  def multiple_create

    return if nothing_to_save(params[:multi_objs], envspecifics_path)

    @multi_objs = params[:multi_objs].collect { |obj| Envspecific.new(obj) }
    respond_to do |wants|
      if multi_save(@multi_objs)
        params[:page] = Envspecific.last_page
        flash[:notice] = 'Environment Specific Files were successfully saved.'
        wants.html { redirect_paginated_to(envspecifics_path) }
        wants.xml  { render :xml => @multi_objs, :status => :created, :location => envspecifics_path }
      else
        @multi_objs.each do |obj|
          @multi_objs_error = obj
          break unless obj.errors.empty?
        end
        wants.html {
          @envspecifics = Envspecific.search_paginated(params, params[:page])
          render :index
        }
        wants.xml  { render :xml => @multi_objs.first.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /envspecifics/1
  # PUT /envspecifics/1.xml
  def update
    @envspecific = Envspecific.find(params[:id])

    respond_to do |format|
      if @envspecific.update_attributes(params[:envspecific])
        flash[:notice] = 'Envspecific was successfully updated.'
        format.html { redirect_to(envspecifics_path) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @envspecific.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /envspecifics/1
  # DELETE /envspecifics/1.xml
  def destroy
    @envspecific = Envspecific.find(params[:id])
    @envspecific.destroy

    respond_to do |format|
      format.html { redirect_to(envspecifics_url) }
      format.xml  { head :ok }
    end
  end
end
