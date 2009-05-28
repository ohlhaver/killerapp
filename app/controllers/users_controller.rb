class UsersController < ApplicationController
  
  before_filter :login_required, :only => [:settings, :link_user_accounts, :grant_email_permission, :friends, :friends_actions, :profile, :favorite_authors, :articles_by_favorite_authors]
  def friends
    return unless @current_user.fb_offline_access_permission_granted 
    @user = get_user
  end
  def friends_actions
    return unless @current_user.fb_offline_access_permission_granted 
    @user = @current_user
  end

  def profile 
    @user = get_user
  end
  def favorite_authors
    @user = get_user
  end
  def articles_by_favorite_authors
    @user = get_user
    @user_stories =[]
    unless @user.stories.blank?
      story_ids     = @user.stories.split(' ')*","
      @user_stories = Rawstory.find(:all,
                                   :conditions => ["rawstories.id IN ( #{story_ids} ) and rawstory_details.is_duplicate = :false", {:false => false}],
                                   :order      => "rawstories.id DESC",
                                   :joins      => 'inner join rawstory_details on rawstory_details.rawstory_id = rawstories.id',
                                   :limit      => 25)
   
   end
   @user_stories = @user_stories.paginate :page => params[:page],
                                                :per_page => 5                                             

  end
  def grant_email_permission
    @current_user.grant_email_permission  if !@current_user.fb_email_permission_granted and @current_user.fb_user.has_permission?('email')
    redirect_to :back
  end
  def link_user_accounts
     # Connect accounts
     @current_user.link_fb_connect(facebook_session.user.id) unless @current_user.fb_user_id == facebook_session.user.id
     @ask_offline_access   = nil
     @ask_email_permission = nil
     if not @current_user.fb_offline_access_permission_granted 
       if @current_user.fb_user.has_permission?('offline_access')
         @current_user.add_infinite_session_key(facebook_session.session_key)
       else
         @ask_offline_access = true
         return
       end
     else
       @current_user.add_infinite_session_key(facebook_session.session_key)
     end
     if not (@current_user.jurnalo_user or @current_user.fb_email_permission_granted)
       if @current_user.fb_user.has_permission?('email')
         @current_user.grant_email_permission
         @current_user.register_user_to_fb
       else
         @ask_email_permission = true
         return
       end
     end
     redirect_back_or_default(:controller => 'groups', :action => 'index', :l => @l)
   end
    
  # render new.rhtml
  def new
     if @language == 2
        render :action => 'new_d'
      else
        render :action => 'new_e'
      end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.alerts = true
    
    if @language == 2
        @user.language = 2
    else
        @user.language = 1
    end
    
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      self.current_user = nil
      #redirect_back_or_default('/')
      redirect_to :controller => 'groups', :action => 'index', :l => @l
      if @language == 2
          flash[:notice] = "Vielen Dank für die Anmeldung! Bitte checken Sie Ihre E-mail um sich zu authentifizieren."
        else
          flash[:notice] = "Thanks for signing up! Please check your email to authenticate yourself."
        end
    
    else
      if @language == 2
          render :action => 'new_d'
        else
          render :action => 'new_e'
        end
    end
  end

  def activate
    self.current_user = params[:activation_code].blank? ? false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      if @language == 2
      flash[:notice] = "Anmeldung fertig!"
      else
      flash[:notice] = "Signup complete!"
    end
    end
    #redirect_back_or_default('/')
    redirect_to :controller => 'groups', :action => 'index', :l => @l
  end

  def forgot_password
    if request.post?
      if params[:login_or_email_address]
        user = (/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).match(params[:login_or_email_address]).nil? ? User.find_by_login(params[:login_or_email_address]) : User.find(:first, :conditions => ["email = ? ", params[:login_or_email_address]])
        if user
          new_password               = Array.new(12) { (rand(122-97) + 97).chr }.join
          user.password              = new_password
          user.password_confirmation = new_password
          user.save!
          # Send email
          UserMailer.deliver_credentials_email(user)
          redirect_to login_url(:l => @l)
          
            if @language == 2
            flash[:notice] = "Ein neues Passwort ist an Ihre Adresse gesandt worden. Bitte checken Sie Ihre Mail."
            else
            flash[:notice] = "A new password has been sent to your email address. Please check your e-mail."
            end
          
          
        else
          
            if @language == 2
            flash[:notice] = "Diesen Benutzernamen oder diese E-mail Adresse gibt es nicht."
            else
            flash.now[:notice] = "The login or e-mail address does not exist."
            end
          
        end
      else
        
        if @language == 2
        flash.now[:notice] = "Bitte geben Sie Ihren Benutzernamen oder Ihre E-mail Adresse an."
        else
        flash.now[:notice] = "Please provide your login or e-mail address."
        end
      end
    end
  end

  def settings
    if request.post?
       
      # Settings : Email Alerts
      if params[:setting_type] == 'email' and params[:alerts] and (params[:alerts] == "true") != @current_user.alerts
        @current_user.update_attribute(:alerts, (params[:alerts] == "true"))
        if @language == 2
        flash.now[:notice] = "Sie haben erfolgreich Ihre E-mail Einstellungen verändert."
        else
        flash.now[:notice] = "You have successfully updated your e-mail settings."
        end
        return
      end

      # Settings : Language
      if params[:setting_type] == 'language'
         @current_user.language = (params[:search_language] == '1')? 3 : @language
         @current_user.save!
         if @language == 2
         flash.now[:notice] = "Sie haben erfolgreich Ihre Sprach-Einstellungen verändert."
         else
         flash.now[:notice] = "You have successfully updated your language settings."
         end
         return
      end

      # Settings : Password 
      if params[:setting_type] == 'password' and params[:password]
        # If the current password is correct, update the password
        if @current_user.authenticated?(params[:password][:current])
          if params[:password][:new] == params[:password][:confirmation]
            @current_user.password              = params[:password][:new]
            @current_user.password_confirmation = params[:password][:confirmation]
            @current_user.save!
            if @language == 2
            flash.now[:notice] = "Sie haben erfolgreich Ihr Passwort geändert."
            else
            flash.now[:notice] = "You have successfully updated your password."
            end
          else
            if @language == 2
            flash.now[:notice] = "Ihr neues Passwort und dessen Bestätigung stimmen nicht überein."
            else
            flash.now[:notice] = "Your new password and its confirmation do not match."
            end
          end
        else
          if @language == 2
          flash.now[:notice] = "Falsches Passwort."
          else
          flash.now[:notice] = "Incorrect password."
          end
        end
      end

    end
  end

  protected
  def get_user
    if params[:id]
      user = User.find(params[:id])
    elsif params[:fb_user_id]
      user = User.find_by_fb_user_id(params[:fb_user_id])
    else
      user = @current_user
    end
    user
  end

end
