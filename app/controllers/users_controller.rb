class UsersController < ApplicationController
  
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
    @user.save
    if @user.errors.empty?
      self.current_user = @user
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
      flash[:notice] = "Anmeldung fertig!"
    end
    #redirect_back_or_default('/')
    redirect_to :controller => 'groups', :action => 'index', :l => @l
  end

end
