# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ExceptionNotifiable
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '30f91683eea1d7b3b2b38a0fba2e45ba'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :language?
  before_filter :logged_in?
 
  require 'will_paginate'
  
  protected

  def language?
    if params[:l] == 'd'
      @language = 2
      @l='d'
    else
      @language = 1
      @l='e'
    end
  end
  
end
