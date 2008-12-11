module TopicsHelper
  
  def create_topic_slogan
    if @language ==2
      label = 'Bitte geben Sie einen Suchbegriff ein. Ihr neues Thema wird die neuesten Nachrichten zu diesem Suchbegriff anzeigen.'
    else
      label = 'Please enter a search term. Your new topic will show the latest news for this search term.'
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
