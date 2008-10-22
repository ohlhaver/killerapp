# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  
   
   def search_label
     
      if @language ==2
      label = 'Suche'
      else
      label = 'search' 
      end
    
    return label
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
      label = 'Schlagzeilen'
    else
      label = 'Top stories'
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
      label = 'Meinungen'
    else
      label = 'Opinions'
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
  
  
  
 
end
