module SubscriptionsHelper
  def authors_list_label
    if @language ==2
    label = 'Liste der Autoren'
    else
    label = 'List of authors' 
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
  
  def subscribe_label

    label = 'subscribe to emails' 

    
    return label
  end
  
  def unsubscribe_label
    
    label = 'unsubscribe from emails' 

    return label
  end
end
