class TopicsController < ApplicationController
  before_filter :login_required
  
  def new
    
  end
  
 
  def create
    if @current_user.searchterms == nil
      @current_user.searchterms = params[:searchterms] + ',' if params[:searchterms] != '' && params[:searchterms].size < 16
    else  
      @current_user.searchterms += params[:searchterms] + ',' if params[:searchterms] != '' && params[:searchterms].size < 16
    end
    if @searchterms == nil
      @current_user.save 
    else
      @current_user.save if @searchterms.size < 10
    end
    
    if params[:searchterms] != '' && params[:searchterms].size < 16
      
    redirect_to search_rawstories_path(:l => @l, :q => params[:searchterms]) 
    flash[:notice] = "Sie haben ein neues Thema erstellt." if @language == 2
    flash[:notice] = "You have created a new topic." if @language == 1
    else
    render :action => 'new'
    end
    

  end
  
  def delete
    trash = params[:q] + ','
    @current_user.searchterms = @current_user.searchterms.sub(trash,'')
    @current_user.save
    redirect_to :back
    flash[:notice] = "Sie haben das alte Thema gelöscht." if @language == 2
    flash[:notice] = "You have deleted the old topic." if @language == 1
  end
  
      
  
end
