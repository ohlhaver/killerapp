class TopicsController < ApplicationController
  before_filter :login_required
  
  def new
    
  end
  
 
  def create
    @current_user.searchterms = params[:searchterms] if params[:searchterms] != '' && params[:searchterms].size < 16
    @current_user.save
    
    if @current_user.searchterms
    redirect_to search_rawstories_path(:l => @l, :q => @current_user.searchterms) 
    flash[:notice] = "Sie haben ein neues Thema erstellt." if @language == 2
    flash[:notice] = "You have created a new topic." if @language == 1
    else
    render :action => 'new'
    end
    

  end
  
  def delete
    @current_user.searchterms = nil
    @current_user.save
    redirect_to :back
    flash[:notice] = "Sie haben das alte Thema gelöscht." if @language == 2
    flash[:notice] = "You have deleted the old topic." if @language == 1
  end    
  
end
