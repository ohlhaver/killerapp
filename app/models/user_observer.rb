class UserObserver < ActiveRecord::Observer
  def after_create(user)
    HomePageConf.create!(:user_id => user.id)
    UserMailer.deliver_signup_notification(user) unless user.facebook_user?
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if !user.facebook_user? and user.recently_activated?
  end
end
