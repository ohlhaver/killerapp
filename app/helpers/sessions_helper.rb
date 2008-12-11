module SessionsHelper
  
  def login_message
  if @language == 2
    label = 'Sobald Sie eingeloggt sind, können Sie alle Artikel Ihrer Lieblingsautoren erhalten und Ihre eigenen Themen erstellen.'
  else
    label = 'Once logged in, you can get all articles by your favourite authors and create your own topics.'
  end
  end
end