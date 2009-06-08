class NotificationsController < ApplicationController
  before_filter :login_required
  def view_new_friends
    @notifications =  ProfileNotification.from_valid_users(@current_user.new_friend_notifications, @current_user.jurnalo_friends)
    render :action => 'view'
  end
  def view
    @notifications =  (ProfileNotification.from_valid_users(@current_user.new_friend_notifications, @current_user.jurnalo_friends).to_a + Recommendation.from_valid_users(@current_user.recommendations, @current_user.jurnalo_friends).to_a).sort_by{|s| s.created_at}.reverse
    render :action => 'view'
  end
end
