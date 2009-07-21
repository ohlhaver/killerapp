module AuthorsHelper
  def articles_by_label author
    if @language == 2
      label = 'Artikel von '
    else
      label = 'Articles by'
    end
  end
  
  def add_to_my_authors_label
    if @language ==2
      label = 'abonnieren' 
    else
      label = 'subscribe' 
    end
    return label
  end

  def remove_from_my_authors_label
    if @language ==2
      label = 'abbestellen' 
    else
      label = 'unsubscribe' 
    end
    return label
  end
  
  def share_label
    if @language ==2
      label = 'empfehlen' 
    else
      label = 'share'
    end
    return label
  end
  def recommend_label
    if @language ==2
      label = 'empfehlen' 
    else
      label = 'recommend'
    end
    return label
  end
  
  
  
end
