class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    = 'Bitte aktivieren Sie Ihren neuen Jurnalo Zugang'
  
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    = 'Ihr Jurnalo Zugang wurde aktiviert!'
    @body[:url]  = "http://#{SITE_URL}/"
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
