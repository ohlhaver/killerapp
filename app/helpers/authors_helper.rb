module AuthorsHelper
  def articles_by_label author
    if @language == 2
      label = 'Artikel von '
    else
      label = 'Articles by'
    end
  end
end
