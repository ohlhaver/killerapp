# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include AuthenticatedSystem
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '30f91683eea1d7b3b2b38a0fba2e45ba'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  before_filter :logged_in?
  
  before_filter :determine_selection
  
  #protected
  
  def determine_selection
   @selection = 'Schlagzeilen' if params[:action] == 'index' && params[:controller] == 'groups'
   @selection = 'Politik' if params[:action] == 'politics'
   @selection = 'Feuilleton' if params[:action] == 'culture'
   @selection = 'Wirtschaft' if params[:action] == 'business'
   @selection = 'Wissen' if params[:action] == 'science'
   @selection = 'Technik' if params[:action] == 'technology'
   @selection = 'Vermischtes' if params[:action] == 'mixed'
   @selection = 'Sport' if params[:action] == 'sport'
   @selection = 'Meinungen' if params[:action] == 'opinions'

   #@selection = 'Ähnliche Artikel' if params[:controller] == 'haufens' && params[:action] == 'show'
   #@selection = 'Meinungen' if params[:controller] == 'haufens' && params[:action] == 'filter_haufen_by_opinions'
   end

   def determine_german_date
    t = Time.now

    m = t.mon

   month = 'Januar' if m == 1
   month = 'Februar' if m == 2
   month = 'März' if m == 3
   month = 'April' if m == 4
   month = 'Mai' if m == 5
   month = 'Juni' if m == 6
   month = 'Juli' if m == 7
   month = 'August' if m == 8
   month = 'September' if m == 9
   month = 'Oktober' if m == 10
   month = 'November' if m == 11
   month = 'Dezember' if m == 12

   #clock = t.strftime('%I:%M Uhr')
   day = t.mday.to_s

   @date = ' - ' + day +'. ' + month #+ ' ' + clock

   end
  
end
