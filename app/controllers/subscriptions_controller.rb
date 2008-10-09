class SubscriptionsController < ApplicationController

before_filter :login_required
  
  def show
      @subscriptions = @current_user.subscriptions.find(:all)
      @subscriptions = @subscriptions.sort_by {|s| s.author.name }
  end

def index
 
   @authors = @current_user.authors
   @user_rawstories = []
   @authors.each do |a|
     @user_rawstories = @user_rawstories + a.rawstories.last(3)
   end
   @user_rawstories = @user_rawstories.sort_by {|u| - u.id }  
   @user_rawstories = @user_rawstories.paginate :page => params[:page],
                                                :per_page => 8                                             
end




  def remove
   @subscription = Subscription.find(params[:id])
   Subscription.destroy(@subscription) if @subscription.user.id == @current_user.id
   redirect_to :action => 'index'
  end


    def subscribe
      if @current_user.login
      @current_user.subscriptions.create(:author_id => params[:id]) if Author.find(params[:id])
      end

      redirect_to :controller => 'subscriptions', :action => 'index'
    end
  
  
  
end
