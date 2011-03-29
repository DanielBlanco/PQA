# Put Configurations control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Configuration's Controller class.
#
class ConfigurationsController < ApplicationController

  skip_before_filter :get_project

  # Runs before any action in the controller.
  before_filter :find_configuration, :only => [:show, :edit, :update, :destroy]

  # Index Action.
  # GET /configurations
  # GET /configurations.xml
  def index
    @configurations = Configuration.search_paginated(params, params[:page])
    flash_on_empty @configurations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @configurations }
    end
  end

  # Show Action.
  # GET /configurations/1
  # GET /configurations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @configurations }
    end
  end

  # Edit Action.
  # GET /configurations/1/edit
  def edit
  end

  # Update Action.
  # PUT /configurations/1
  # PUT /configurations/1.xml
  def update
    respond_to do |format|
      if @configuration.update_attributes(params[:configuration])
        flash[:notice] = 'Configuration was successfully updated.'
        format.html { redirect_to(@configuration) }
        format.xml  { head :ok }
      else
        logger.error @configuration.errors.full_messages.join('; ')
        flash[:error] = 'Error updating configuration: '
        format.html { render :action => "edit" }
        format.xml  { render :xml => @configuration.errors, :status => :unprocessable_entity }
      end
    end
  end

  # Destroy Action.
  # DELETE /configurations/1
  # DELETE /configurations/1.xml
  def destroy
    @configuration.destroy

    respond_to do |format|
      flash[:notice] = 'Configuration deleted.'
      format.html { redirect_to(configurations_url) }
      format.xml  { head :ok }
    end
  end

  # From here all functions are private.
  private

  # Find the post defined by param :id.
  def find_configuration
    @configuration = Configuration.find(params[:id])
  rescue
    flash[:error] = "Configuration #{params[:id]} not found!"
    redirect_to configurations_url
  end

end
