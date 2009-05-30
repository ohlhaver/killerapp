class UserMailer < ActionMailer::Base
  def recommended_email(recommendation)
    setup_email(recommendation.user)
    if recommendation.user.language == 2
      @subject    = "#{recommendation.recommender.fb_user.first_name} recommended an #{recommendation.article? ? 'article' : 'author' } to you"
      @body[:recommendation]  = recommendation
      @body[:url]  = "http://#{SITE_URL}/recommendations/view?l=d"
      @body[:author_url]  = "http://#{SITE_URL}/authors/#{recommendation.resource_id}?l=d" if recommendation.author?
      
    else
      @subject    = "#{recommendation.recommender.fb_user.first_name} recommended an #{recommendation.article? ? 'article' : 'author' } to you"
      @body[:recommendation]  = recommendation
      @body[:url]  = "http://#{SITE_URL}/recommendations/view?l=e"
      @body[:author_url]  = "http://#{SITE_URL}/authors/#{recommendation.resource_id}?l=e" if recommendation.author?
    end
  end
  def signup_notification(user)
    setup_email(user)
    if user.language == 2
    @subject    = 'Bitte aktivieren Sie Ihren Jurnalo Zugang!' 
    @body[:url]  = "http://www.jurnalo.com/activate/#{user.activation_code}?l=d"
    else
    @subject    = 'Please activate your new Jurnalo account!'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}?l=e"
    end
    
  end

  def credentials_email(user)
    setup_email(user)
    if user.language == 2
      @subject    = 'Ihr neues Passwort für Jurnalo!' 
      @body[:url]  = "http://www.jurnalo.com/session/new?l=d"
    else
      @subject    = 'Your new password for Jurnalo!'
      @body[:url]  = "http://www.jurnalo.com/session/new?l=e"
    end
    
  end

  
  def activation(user)
    setup_email(user)
    if user.language == 2  
      @subject    = 'Ihr Jurnalo Zugang ist nun aktiviert!'
      @body[:url]  = "http://www.jurnalo.com/?l=d"  
    else    
    @subject    = 'Your Jurnalo account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/?l=e"
    end
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
    
      @user_new_stories =[]
       if user.new_stories
        story_array = user.new_stories.split(/\ /)
        story_array.each do |story|
           @user_new_stories += Rawstory.find(story).to_a
        end
      end
      
    user.new_stories = nil
    user.save
    
     setup_email(user)
     if user.language == 2
       @subject    = 'Neue Artikel von Ihren Lieblingsautoren'
       @body[:url]  = "http://www.jurnalo.de/" 
       @body[:user_new_stories] = @user_new_stories
       @body[:my_authors_link] = "http://www.jurnalo.com/subscriptions?l=d"
       @body[:from] = "#{SITE_EMAIL}"
     else
       @subject    = 'New articles by your favorite authors'
       @body[:url]  = "http://#{SITE_URL}/" 
       @body[:user_new_stories] = @user_new_stories
       @body[:my_authors_link] = "http://#{SITE_URL}/subscriptions?l=e"
       @body[:from] = "#{SITE_EMAIL}"
       
     end
         

  
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
