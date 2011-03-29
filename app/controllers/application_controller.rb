# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :flash_keys, :project?, :pagination_page, :business_mashups_url, :pagination_number

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '22afd881bccb17b03719253f653aaebc'

  # If you don't want these filters to apply to your controller class
  # use skip_before_filter :get_project
  # TODO: Cannot do this because the flash hash will be empty even in
  # redirects which causes that show action does not display the success
  # messages
  # prepend_before_filter :initialize_flash_types

  # Before filter to get the project.
  before_filter :get_project

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  private # Methods from here are private.

  #
  # View Model errors in a html structure.
  # Each error is break with a <br/> tag.
  #
  def view_model_errors(model)
    model.errors.empty? ? '' : model.errors.full_messages.join('.<br/> ')
  end

  #
  # Put all model errors into flash[:error] unless there are no errors
  # in the model.
  #
  def flash_model_errors(model, prefix_msg='')
    flash[:error] = prefix_msg + view_model_errors(model) unless model.errors.empty?
  end

  #
  # Logs the model errors if an error ocurred.
  #
  def log_model_errors(model)
    logger.error view_model_errors(model) unless model.errors.empty?
  end

  #
  # Get the project specified in params hash by :project_id symbol.
  # If the project is not found a error message is sent to the user and
  # the page is redirected to project list page.
  #
  def get_project
    @project = Project.find(params[:project_id])
  rescue
    flash[:error] = "Project #{params[:project_id]} not found!"
    redirect_to projects_url
  end

  # Flash notice keys, :back, :confirm, :error, :info, :warn are others.
  def flash_keys
    [:error, :notice, :warning]
  end

  # Checks if a project is in use.
  def project?
    !(@project.nil? || @project.id.nil?)
  end

  #
  # Adds a msg in the flash hash if the array or object received
  # as param is null or empty.
  # == Examples
  #  flash_on_empty @projects
  #  flash_on_empty @projects, 'There are no projects to show'
  #  flash_on_empty @projects, 'There are no projects to show', :error
  #
  def flash_on_empty(obj, msg='There are no records to show.', sym=:notice)
    flash[sym] = msg if obj.nil? || obj.empty?
  end

  #
  # Resets the flash array whenever a call is made to our controllers.
  #
  def initialize_flash_types
    flash.clear
  end

  #
  # Saves a project association into database:
  # * If successed then a success_msg is put into flash[:notice].
  # * If failed the error is logged and put into flash[:error].
  #
  # ==Options
  # * obj => Model to save.
  # * success_msg => Default is 'Saved!'
  #
  # ==Example
  #   create_project_association(@walkthrough)
  #   create_project_association(@walkthrough, 'Walkthrough issue was successfully created.')
  #   create_project_association(@walkthrough, 'Walkthrough issue was successfully created.', 'Error creating walkthrough: ')
  #
  def create_project_association(obj, success_msg='Saved!', failure_msg='')
    respond_to do |format|
      if obj.save
        flash[:notice] = success_msg
        format.html { redirect_paginated_to [@project, obj] }
        format.xml  { render :xml => obj, :status => :created, :location => obj }
      else
        log_model_errors obj
        flash_model_errors obj, failure_msg
        format.html { render :action => "new" }
        format.xml  { render :xml => obj.errors, :status => :unprocessable_entity }
      end
    end
  end

  # if nothing to save return true, else false.
  def nothing_to_save(obj, url, msg='Nothing to save')
    unless obj
      respond_to do |format|
        flash[:warning] = msg if request.post?
        format.html { redirect_paginated_to(url) }
        format.xml { render :xml => xml_error(flash[:warning]), :status => :unprocessable_entity }
      end
      return true
    end
    false
  end

  # Returns the current page in pagination.
  def pagination_page
    params[:page] ||= 1
    params[:page]
  end

  # Returns the current page in pagination.
  def redirect_paginated_to(url)
    redirect_to url_for(url) + "?page=#{pagination_page}"
  end

  # Returns the business mashups url
  def business_mashups_url
    bm = Configuration.business_mashups
    return bm.config_values if bm
    '' #=> Empty url if there is not a business_mashups object.
  end

  # Returns the business mashups url
  # ===NOTE:
  # If you update this method, also update the one in lib/search_engine.rb
  def pagination_number
    pn = Configuration.pagination_number
    return pn.config_values if pn
    10 #=> Empty url if there is not a pagination_number object.
  end

  # Saves the given objects into database, returning true if everything
  # went well or false if anything failed.
  # ===NOTE:
  # This method will save the objects in a transaction, if anyone of
  # them fails for whatever reason, NONE of them will be saved.
  def multi_save(objs)
    # First let's be sure the objects are in good shape.
    return false unless objs.all?(&:valid?)

    # Let's start a transaction and save the objects.
    objs.first.transaction do
      objs.each(&:save!)
    end
  rescue
    # This is a hack to avoid a 500 error when submitting a page.
    objs.each do |obj|
      obj.id = nil
    end
    false
  end

end
