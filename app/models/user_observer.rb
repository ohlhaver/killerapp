class UserObserver < ActiveRecord::Observer
  def after_create(user)
    HomePageConf.create!(:user_id => user.id)
    UserMailer.deliver_signup_notification(user) unless user.facebook_user?
  end

  def after_save(user)
  
    UserMailer.deliver_activation(user) if !user.facebook_user? and user.recently_activated?
    
    if user.new_stories != "" && user.alerts == true && user.new_stories
      if not user.jurnalo_user and user.facebook_user?
        fb_session = Facebooker::Session.create
        e = UserMailer.create_change_alert(user) 
        fb_session.send_email([user.fb_user_id], e.subject, e.body)
      else
        UserMailer.deliver_change_alert(user) 
      end
    end
  
  end
end
