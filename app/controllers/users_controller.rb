class UsersController < ApplicationController
  
  before_filter :login_required, :only => [:settings]
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
          flash[:notice] = "Vielen Dank für die Anmeldung! Bitte checken Sie Ihre Email um sich zu authentifizieren."
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
          redirect_to login_url
          flash[:notice] = "A new password has been created and sent to your email address. Please check your email box."
        else
          flash.now[:notice] = "The login/email address does not exist"
        end
      else
        flash.now[:notice] = "Provider your login or email address"
      end
    end
  end

  def settings
    if request.post?
       
      # Settings : Email Alerts
      if params[:setting_type] == 'email' and params[:alerts] and (params[:alerts] == "true") != @current_user.alerts
        @current_user.update_attribute(:alerts, (params[:alerts] == "true"))
        flash.now[:notice] = "Successfully updated"
        return
      end

      # Settings : Language
      if params[:setting_type] == 'language'
         @current_user.language = (params[:search_language] == '1')? 3 : @language
         @current_user.save!
         flash.now[:notice] = "Successfully updated"
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
            flash.now[:notice] = "Successfully updated"
          else
            flash.now[:notice] = "The new password and confirmation do not match"
          end
        else
          flash.now[:notice] = "Incorrect password"
        end
      end

    end
  end

end
