class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user)
  end

  def after_save(user)
  
    UserMailer.deliver_activation(user) if user.recently_activated?
    
    UserMailer.deliver_change_alert(user) if user.new_stories != "" && user.alerts == true && user.new_stories
  
  end
end
