class AboutController < ApplicationController

  def feedback
    if params[:feedback] != nil
      feedback = params[:feedback] 
      UserMailer.deliver_feedback_mail @current_user, feedback
    
      redirect_back_or_default('/')
      flash[:notice] = "Vielen Dank für Ihr überaus intelligentes Feedback!"
    
    end
    
  end

end
