module AuthenticatedSystem
  protected
    # Returns true or false if the user is logged in.
    # Preloads @current_user with the user model if they're logged in.
    def logged_in?
      !!current_user
    end
    def logged_in_with_facebook_account?
      val = defined?(@logged_in_with_facebook_account) and @logged_in_with_facebook_account
      unless val
        flash[:notice] = 'Please login with facebook account to access this feature'
        access_denied
      end
    end
    # Accesses the current user from the session. 
    # Future calls avoid the database because nil is not equal to false.
    def current_user
      if @current_user != false  and @current_user.blank?
        @current_user ||= (login_from_session || login_from_basic_auth || login_from_cookie || login_from_fb) 
      end
      if facebook_session && facebook_session.user
        @current_user.fb_user = facebook_session.user
        @logged_in_with_facebook_account = true
      end
      @current_user
    end

    # Login with facebook account 
    def login_from_fb
      if facebook_session and !facebook_session.expired?
        #self.current_user = User.find_by_fb_user(facebook_session.user)
        self.current_user = User.find_by_fb_user(facebook_session.user) || User.create_from_fb_connect(facebook_session.user)
        @current_user
      end
    end

    # Store the given user id in the session.
    def current_user=(new_user)
      session[:user_id] = new_user ? new_user.id : nil
      @current_user = new_user || false
    end

    # Check if the user is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the user
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_user.login != "bob"
    #  end
    def authorized?
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      authorized? || access_denied
    end

    def facebook_login_required
      authorized? && logged_in_with_facebook_account?
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to new_session_path(:l => @l)
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end
    def set_last_page_viewed
      unless params[:controller] == 'sessions' or 
             params[:action] == 'image' or
             (params[:controller] == 'users' and 
              ['link_user_accounts', 'grant_email_permission'].include?(params[:action]) ) or 
             (params[:controller] == 'subscriptions' and params[:action] == 'subscribe') or 
             (params[:controller] == 'recommendations' and ['recommend_author', 'recommend_article'].include?(params[:action]))
        session[:last_page_viewed] =  request.request_uri 
      end
    end

    def redirect_to_last_page_viewed_or_default(default=nil)
      redirect_to(session[:last_page_viewed] || default || :back)
      session[:last_page_viewed] = nil
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_user, :logged_in?
    end

    # Called from #current_user.  First attempt to login by the user id stored in the session.
    def login_from_session
      self.current_user = User.find_by_id(session[:user_id]) if session[:user_id]
    end

    # Called from #current_user.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |username, password|
        self.current_user = User.authenticate(username, password)
      end
    end

    # Called from #current_user.  Finaly, attempt to login by an expiring token in the cookie.
    def login_from_cookie
      user = cookies[:auth_token] && User.find_by_remember_token(cookies[:auth_token])
      if user && user.remember_token?
        cookies[:auth_token] = { :value => user.remember_token, :expires => user.remember_token_expires_at }
        self.current_user = user
      end
    end
end
