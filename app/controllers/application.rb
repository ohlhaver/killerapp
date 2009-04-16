# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :iphone_user_agent?
  include ExceptionNotifiable
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '30f91683eea1d7b3b2b38a0fba2e45ba'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :logged_in?
  before_filter :adjust_format_for_iphone  
  before_filter :language?
  before_filter :fetch_searchterms
 

 
  require 'will_paginate'
  
  protected

  def language?
    @adresse = request.url
    redirect_to 'http://www.jurnalo.com' if @adresse.match('74.63.8.37')
    redirect_to 'http://www.jurnalo.com' if @adresse.match('journalo.com')
    redirect_to 'http://www.jurnalo.de' if @adresse.match('journalo.de')
    redirect_to 'http://www.jurnalo.com' if @adresse.match('//jurnalo.com')
    redirect_to 'http://www.jurnalo.de' if @adresse.match('//jurnalo.de')
    
    if @adresse.match('lo.de') or params[:l] == 'd'
      @language = 2
      @l='d'
    else  
      @language = 1
      @l='e'
    end
    
    @i = 1 if params[:i] == '1'
    
    if logged_in?
      if @current_user.language == 3
        @i=1  
      end
    end
    
  end
  
  def adjust_format_for_iphone
    request.format = :iphone if iphone_user_agent?
  end
  
  def iphone_user_agent?
    #
    #return (params[:format] == "iphone")
   params[:man_agent] == 'iphone' or (request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/])
  #return true
  end
  
  def iphone_subdomain?
    return request.subdomains.first == "iphone"
  end
  
  def fetch_searchterms
    if logged_in?
    @searchterms = @current_user.searchterms.split(/\,/) if  @current_user.searchterms
    else
    @searchterms = nil
    end
  end
  
  
end
