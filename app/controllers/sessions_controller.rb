class SessionsController < ApplicationController
  def create 
    if User.find_by_login_and_password(params[:login], params[:password]) != nil
     @current_user = User.find_by_login_and_password(params[:login], params[:password])
    end
   

      if @current_user.login
        session[:user_id] = @current_user.id
        if session[:return_to]
          redirect_to session[:return_to]
          session[:return_to] = nil
        else    
        redirect_to groups_path
        end
      else
        render :action => 'new'
      end
  end

  def new
    unless logged_in?
      @current_user = User.create
      session[:user_id] = @current_user.id
      redirect_to groups_path 
    end    
  end

  def destroy
    session[:user_id] = @current_user = User.create
  end

end
