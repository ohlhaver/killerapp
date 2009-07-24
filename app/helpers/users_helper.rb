module UsersHelper
  
  def request_password_message
  if @language == 2
    label = 'Bitte geben Sie Ihren Benutzernamen oder E-mail Adresse ein. Wir schicken Ihnen ein neues Passwort.'
  else
    label = 'Please enter your login or e-mail address. We will send you a new password.'
  end
  end
  
  def request_password_field_label
  if @language == 2
    label = 'Benutzername oder E-mail Adresse'
  else
    label = 'Login or e-mail address'
  end
  end
  
  def forgot_password_button
  if @language == 2
    label = 'absenden'
  else
    label = 'submit'
  end
  end
 
 
  def change_language_label
  if @language == 2
    label = 'Deutsche und englische Suchergebnisse'
  else
    label = 'English and German search results'
  end
  end
 
  def switch_email_alerts_label
  if @language == 2
    label = 'E-mail Benachrichtigungen bei neuen Artikeln meiner Lieblingsautoren'
  else
    label = 'E-mail alerts for new articles by my favorite authors'
  end
  end
  
  def password_label
  if @language == 2
    label = 'Bisheriges Passwort'
  else
    label = 'Current password'
  end
  end
  
  def new_password_label
  if @language == 2
    label = 'Neues Passwort'
  else
    label = 'New password'
  end
  end
  
  def confirm_password_label
  if @language == 2
    label = 'Passwort bestätigen'
  else
    label = 'Confirm password'
  end
  end
  
  def change_password_label
  if @language == 2
    label = 'Passwort ändern'
  else
    label = 'change password'
  end
  end
  
  def save_label
  if @language == 2
    label = 'speichern'
  else
    label = 'save'
  end
  end
  
  def on_label
  if @language == 2
    label = 'An'
  else
    label = 'On'
  end
  end
  
  def off_label
  if @language == 2
    label = 'Aus'
  else
    label = 'Off'
  end
  end
  
  def immediately_label
  if @language == 2
    label = 'Sofort'
  else
    label = 'Immediately'
  end
  end
  
  def daily_label
  if @language == 2
    label = 'Täglich'
  else
    label = 'Daily'
  end
  end
  
  def weekly_label
  if @language == 2
    label = 'Wöchentlich'
  else
    label = 'Weekly'
  end
  end
  
  def need_fb_connection_label
  if @language == 2
    label = ' Bitte verbinden Sie Ihren Jurnalo Zugang mit Facebook um Ihre Freunde sehen zu können.'
  else
    label = ' Please connect your Jurnalo account with Facebook to be able to view your friends.'
  end
  end
  
  def new_signup_label
  if @language == 2
    label = 'Oder hier als neuer Benutzer anmelden!'
  else
    label = 'Or click here to sign up as a new user!'
  end
  end
  
  
  
end