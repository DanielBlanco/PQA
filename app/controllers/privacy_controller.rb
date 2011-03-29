# Put Privacies control logic in here.
#
# Author::    Daniel (mailto:dblanco@tsys.com)
# Copyright:: Copyright (c) 2009 TSYS.
# License::   ???
#
# Privacy's Controller class.
#
class PrivacyController < ApplicationController
  
  skip_before_filter :get_project

  # /privacy
  def index
  end

end
