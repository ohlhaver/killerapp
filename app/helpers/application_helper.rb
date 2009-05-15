# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def facebook_login_button
   fb_login_button "window.location = '/users/link_user_accounts?l=#{@l}';", 
                  {:size => :medium,:length => :long, :background => :dark}
  end
  def duplicates_label
    if @language ==2
      label = 'Duplikate anzeigen' 
    else
      label = 'show duplicates'
    end
    
    return label

  end
  def articles_list_label
    if @language ==2
      label = 'Artikel'
    else
      label = 'Articles' 
    end
    
    return label
  end

   def search_label
     
      if @language ==2
      label = 'suche'
      else
      label = 'search' 
      end
    
    return label
  end
  
   def settings_label
     
      if @language ==2
      label = 'Einstellungen'
      else
      label = 'Settings' 
      end
    
    return label
  end
  
  def read_list_label
    if @language == 2
      'Leseliste'
    else
      'Reading list'
    end
  end

  def save_to_read_list_label
   if @language == 2
     'Zur Leseliste speichern'
   else
     'Save to reading list'
   end
  end

  def remove_from_read_list_label
   if @language == 2
     'Von der Leseliste entfernen'
   else
     'Remove from reading list'
   end
  end

  
  
  def previous_label
    if @language ==2
    label = 'zurück'
    else
    label = 'previous' 
    end
    
    return label
  end
  
  def next_label
    if @language ==2
    label = 'vorwärts'
    else
    label = 'next' 
    end
    
    return label
  end
  
  
  def my_authors
    if @language ==2
      label = 'Meine Autoren'
    else
      label = 'My authors'
    end
  end
  def login_label
    if @language ==2
      label = 'Einloggen'
    else
      label = 'Login'
    end
  end
  def logout_label
    if @language ==2
      label = '(ausloggen)'
    else
      label = '(logout)'
    end
  end
  
  def topstories_label
    if @language ==2
      label = 'Home'
    else
      label = 'Home'
    end
  end
  def politics_label
    if @language ==2
      label = 'Politik'
    else
      label = 'Politics'
    end
  end
  def business_label
    if @language ==2
      label = 'Wirtschaft'
    else
      label = 'Business'
    end
  end
  def culture_label
    if @language ==2
      label = 'Feuilleton'
    else
      label = 'Culture'
    end
  end
  def science_label
    if @language ==2
      label = 'Wissen'
    else
      label = 'Science'
    end
  end
  def technology_label
    if @language ==2
      label = 'Technik'
    else
      label = 'Technology'
    end
  end
  def sport_label
    if @language ==2
      label = 'Sport'
    else
      label = 'Sport'
    end
  end
  def mixed_label
    if @language ==2
      label = 'Vermischtes'
    else
      label = 'Mixed'
    end
  end
  def opinions_label
    if @language ==2
      label = 'Beliebteste Autoren'
    else
      label = 'Most popular authors'
    end
  end 
  
  
  def topics_label
    if @language ==2
      label = 'Meine Themen'
    else
      label = 'My topics'
    end
  end
  
  
  def imprint_label
    if @language ==2
      label = 'Impressum'
    else
      label = 'About'
    end
  end
  
  def privacy_label
    if @language ==2
      label = 'Datenschutz'
    else
      label = 'Privacy'
    end
  end
  
  def subscribe_label
    if @language ==2
      label = '(anmelden)'
    else
      label = '(subscribe)'
    end
  end
  
  def unsubscribe_label
    if @language ==2
      label = '(abmelden)'
    else
      label = '(unsubscribe)'
    end
  end
  
  def create_topic
    if @language ==2
      label = 'Neues Thema [+]'
    else
      label = 'New topic [+]'
    end
  end
  
  
 
end
