class SubscriptionsController < ApplicationController

before_filter :login_required
  
  def show
      @subscriptions = @current_user.subscriptions.find(:all)
      @subscriptions = @subscriptions.sort_by {|s| s.author.name }
  end

  def index
   @user_stories =[]
   unless @current_user.stories.blank?
     story_ids     = @current_user.stories.split(' ')*","
     @user_stories = Rawstory.find(:all,
                                   :conditions => ["id IN ( #{story_ids} )"],
                                   :order      => "id DESC",
                                   :limit      => 25)
   
   end
   @user_stories = @user_stories.paginate :page => params[:page],
                                                :per_page => 5                                             
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
     flash[:notice] = "Sie haben " + @subscription.author.name + " von der Liste Ihrer Lieblingsautoren entfernt." if @language == 2
      flash[:notice] = "You have removed " + @subscription.author.name + " from your list of favourite authors." if @language == 1
     Subscription.destroy(@subscription) 
     
     redirect_to :back
   end
  end


  def subscribe
    author = Author.find(params[:id])
    if  author && Subscription.find_by_author_id_and_user_id(params[:id], @current_user.id) == nil 
      Subscription.create!(:author_id => params[:id], :user_id => @current_user.id)
      author_stories = Rawstory.find(:all,
                                     :conditions => "author_id = #{author.id}",
                                     :select => "id",
                                     :order  => "id DESC",
                                     :limit => 3)
                                     
      user_stories = ''
      author_stories.each do |story|
          user_stories += story.id.to_s + ' '
      end 
      if @current_user.stories
        @current_user.stories += user_stories
      else
        @current_user.stories = user_stories
      end  
      @current_user.save   
      flash[:notice] = "Sie haben " + author.name + " zur Liste Ihrer Lieblingsautoren hinzugefügt." if @language == 2
      flash[:notice] = "You have added " + author.name + " to your list of favourite authors." if @language == 1
    end
    redirect_to :back  
  end
  
  def get_alerts
    @current_user.alerts = true
    @current_user.save
  redirect_to :back
  end
  
  def stop_alerts
    @current_user.alerts = false
    @current_user.save
    redirect_to :back
  end
  
  
end
