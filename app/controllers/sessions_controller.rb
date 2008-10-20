# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController


  # render new.rhtml
  def new
    if @language == 2
      render :action => 'new_d'
    else
      render :action => 'new_e'
    end
      
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_user.remember_me unless current_user.remember_token?
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      #redirect_back_or_default('/')
      redirect_to :controller => 'groups', :action => 'index', :l => @l
      flash[:notice] = "Erfolgreich eingeloggt." if @language == 2
      flash[:notice] = "Login successful." if @language == 1
    else
       if @language == 2
          render :action => 'new_d'
        else
          render :action => 'new_e'
        end
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Sie haben sich ausgeloggt." if @language == 2
    flash[:notice] = "You have logged out successfully." if @language == 1
    #redirect_back_or_default('/')
    redirect_to :controller => 'groups', :action => 'index', :l => @l
  end
end
