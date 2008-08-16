class SessionsController < ApplicationController
  def create 
  end

  def new
    
    @current_user = User.create
    session[:user_id] = @current_user.id
        redirect_to rawstories_path
  end

  def destroy
    session[:user_id] = @current_user = nil
  end

end
