module TopicsHelper
  
  def create_topic_slogan
    if @language ==2
      label = 'Bitte geben Sie den Suchbegriff für Ihr neues Thema ein.'
    else
      label = 'Please enter the search term for your new topic.'
    end  
  end
  
  def search_term_label
    if @language ==2
      label = 'Suchbegriff'
    else
      label = 'Search term'
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
