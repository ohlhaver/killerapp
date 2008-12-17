module TopicsHelper
  
  def create_topic_slogan
    if @language ==2
      label = 'Ihr neues Thema wird die neuesten Nachrichten zu Ihrem Suchbegriff anzeigen.'
    else
      label = 'Your new topic will show the latest news for your search term.'
    end  
  end
  
  def search_term_label
    if @language ==2
      label = 'Suchbegriff eingeben'
    else
      label = 'Enter search term'
    end  
  end
  
  def create_topic_label
    if @language ==2
      label = 'Thema erstellen'
    else
      label = 'create topic'
    end  
  end
  
end
