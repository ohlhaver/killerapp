class AboutController < ApplicationController

  def feedback
    
    
    if params[:feedback] != nil
      feedback = params[:feedback] 
      UserMailer.deliver_feedback_mail @current_user, feedback
    
      
      if @language == 2
      flash[:notice] = "Vielen Dank für Ihr überaus intelligentes Feedback!"
      else
      flash[:notice] = "Thanks for this extraordinarily intelligent feedback!"
      end
    redirect_to :controller => 'groups', :l => @l
  end
    
  end

  def imprint
    if @language == 2
    render :action => 'impressum' 
    else
    render :action => 'about' 
    end
    
  end
  def privacy
    if @language == 2
    render :action => 'datenschutz' 
    else
    render :action => 'privacy' 
    end
  end
  

end
