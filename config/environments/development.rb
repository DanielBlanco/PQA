# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# Use a different cache store in development: memory_store is default!
# Check railscasts.com episode 115 for more info.
#config.cache_store = :memory_store
#config.cache_store = :file_store, 'path/to/cache'
#config.cache_store = :mem_cache_store
#config.cache_store = :mem_cache_store, :namespace => 'storeapp'
#config.cache_store = :mem_cache_store, '123.456.78.9:1001', '123.456.78.9:1002'

require 'ruby-debug'