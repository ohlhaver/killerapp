class SubscriptionsController < ApplicationController

before_filter :login_required
  
  def show
      @subscriptions = @current_user.subscriptions.find(:all)
      @subscriptions = @subscriptions.sort_by {|s| s.author.name }
  end

  def index
    
   @user_stories =[]
    story_array = @current_user.stories.split(/\ /)
    story_array.each do |story|
       @user_stories += Rawstory.find(story).to_a
    end
  
   
   @user_stories = @user_stories.sort_by {|u| - u.id }  
   @user_stories = @user_stories.first(12)
   @user_stories = @user_stories.paginate :page => params[:page],
                                                :per_page => 6                                             
  end



  def remove
   @subscription = Subscription.find(params[:id])
   if @subscription.user.id == @current_user.id
     
     author_stories = @subscription.author.rawstories.last(3)
     user_stories = ''
     author_stories.each do |story|
         user_stories += story.id.to_s + ' '
     end
     @current_user.stories = @current_user.stories.sub(user_stories,'')
     @current_user.save 
     Subscription.destroy(@subscription) 
     
     redirect_to :action => 'index'
   end
  end


  def subscribe
    if Author.find(params[:id]) && @current_user.subscriptions.find_by_author_id(params[:id]) == nil 
      @current_user.subscriptions.create(:author_id => params[:id]) 
      
      author_stories = Author.find(params[:id]).rawstories.last(3)
      user_stories = ''
      author_stories.each do |story|
          user_stories += story.id.to_s + ' '
      end
      @current_user.stories += user_stories
      @current_user.save   
      redirect_to :controller => 'subscriptions', :action => 'index'
    end
          
  end
  
  
  
end
