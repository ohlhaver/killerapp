# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'uri'
class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  before_filter :set_facebook_session
  helper_method :facebook_session
  
  helper_method :iphone_user_agent?
  #include ExceptionNotifiable
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '30f91683eea1d7b3b2b38a0fba2e45ba'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :logged_in?
  before_filter :adjust_format_for_iphone  
  before_filter :language?
  before_filter :fetch_searchterms
  before_filter :log_request_information
  #before_filter :check_facebook_session
  after_filter  :set_last_page_viewed

 
  require 'will_paginate'
  
  protected
  def check_facebook_session
    if !(params[:controller] == 'sessions' and params[:action] == 'destroy') and @current_user and @current_user.facebook_user? and facebook_session and !facebook_session.logged_into_facebook_connect?
      redirect_to logout_url 
      return false
    end
  end
  def log_request_information
     logger.info "Request : #{request.env.inspect}"
  end
  def www_jurnalo_com_url(address,l='e')
    scheme, user_info, host, port, registry, path, opaque, query, fragment = URI::split(address)
    host = 'www.jurnalo.com'
    s    = query.to_s.split(/(l=[^&]*)/)
    s[1] = "l=#{l}"
    s[0] = s[0].to_s
    s[0] += '&' unless s[0].blank? or s[0].match(/&$/)
    new_query = ''
    s.each{|m| new_query += m}
    URI::Generic.new(scheme,
                     user_info,
                     host,
                     port,
                     registry,
                     path,
                     opaque,
                     new_query,
                     fragment).to_s

  end

  def language?
    @adresse = request.url
    if @adresse.match('74.63.8.37') or @adresse.match('journalo.com') or @adresse.match('//jurnalo.com')
      redirect_to www_jurnalo_com_url(@adresse,'e')
    elsif @adresse.match('journalo.de') or @adresse.match('jurnalo.de')
      redirect_to www_jurnalo_com_url(@adresse,'d')
    end
    
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
   params[:man_agent] == 'iphone' or !(request.env["HTTP_USER_AGENT"].blank? or request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/].blank?)
  #return true
  end
  
  def iphone_subdomain?
    return request.subdomains.first == "iphone"
  end
  
  def fetch_searchterms
    if logged_in?
    @searchterms = @current_user.searchterms.split(/\,/).reverse if  @current_user.searchterms
    else
    @searchterms = nil
    end
  end
  
end
