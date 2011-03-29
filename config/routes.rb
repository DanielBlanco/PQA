ActionController::Routing::Routes.draw do |map|

  # The priority is based upon order of creation: first created -> highest priority.

  map.about '/about', :controller => 'about'

  map.privacy '/privacy', :controller => 'privacy'

  # Dialog mappings: for each item in the array a mapping will be created.
  %w[walkthrough unit_test code_review performance].each do |dlg|
    map.send "#{dlg}_note_dlg", "#{dlg}_note", :controller => 'dialogs', :action => "#{dlg}_note"
  end
  %w[walkthrough unit_test code_review performance project].each do |dlg|
  	map.send "#{dlg}_search_dlg", "#{dlg}_search/:id", :controller => 'dialogs', :action => "#{dlg}_search"
  end

  # Resource mappings.
  map.resources :configurations, :except => [:new, :create]

  map.resources :envspecifics, :collection => {:multiple_create => [:get, :post]}

  map.resources :projects, :member => {:export => :get, :create_excel => :get, :excel => :get},
  :collection => {:redirect => :get} do |project|
    project.resources :walkthroughs,  :collection => {:multiple_create => [:get, :post]}
    project.resources :unit_tests,    :collection => {:multiple_create => [:get, :post]}
    project.resources :code_reviews,  :collection => {:multiple_create => [:get, :post]}
    project.resources :performances,  :collection => {:multiple_create => [:get, :post]}
    project.resources :deployments, :except => [:new],
    :collection => {
      :delete_section => :get,
      :db_section => :get,
      :ts_section => :get,
      :bs_section => :get,
      :sbi_section => :get,
      :create_delete_section => :post,
      :create_db_section => :post,
      :create_ts_section => :post,
      :create_bs_section => :post,
      :create_sbi_section => :post
    }
    project.resources :files, :only => [:index]
  end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'projects'

  # This must be at the end...
  map.connect '*path', :controller => 'projects', :action => 'redirect'
end
