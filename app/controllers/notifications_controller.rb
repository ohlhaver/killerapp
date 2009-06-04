class NotificationsController < ApplicationController
  before_filter :login_required
  def view_new_friends
    @notifications =  @current_user.new_friend_notifications
    render :action => 'view'
  end
  def view
    @notifications =  (@current_user.notifications.to_a + @current_user.recommendations.to_a).sort_by{|s| s.created_at}.reverse
    render :action => 'view'
  end
end
