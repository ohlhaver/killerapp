class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    = 'Please activate your new Jurnalo account!'
  
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    = 'Your Jurnalo account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def feedback_mail(user, feedback)
    @recipients  = "ohlhaver@gmail.com"
    @from = "#{SITE_EMAIL}"
    @subject = "Feedback for Jurnalo"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:text] = feedback
  
  end
  
  
  def change_alert(user)
     setup_email(user)
      @subject    = 'New articles by your favorite authors'
      
      @body[:url]  = "http://#{SITE_URL}/"
  
      @user_new_stories =[]
       if user.new_stories
        story_array = user.new_stories.split(/\ /)
        story_array.each do |story|
           @user_new_stories += Rawstory.find(story).to_a
        end
      end
      
    @body[:user_new_stories] = @user_new_stories
    @body[:my_authors_link] = "http://#{SITE_URL}/subscriptions"
    @body[:from] = "#{SITE_EMAIL}"
    
    user.new_stories = nil
    user.save  
  
  end
  
  
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{SITE_EMAIL}"
      @subject     = "#{SITE_NAME}"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
