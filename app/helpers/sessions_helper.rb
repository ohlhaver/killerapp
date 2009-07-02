module SessionsHelper
  
  def login_message
  if @language == 2
    label = 'Sobald Sie angemeldet sind, können Sie: <br><br>
    - Autoren abonnieren<br>
    - Themen erstellen<br>
    - Artikel zur Leseliste speichern<br>
    - Artikel und Autoren mit Ihren Freunden austauschen'
  else
    label = 'Once signed up, you can:<br><br>
    - subscribe to any author<br> 
    - create topics<br> 
    - save articles to your reading list<br>
    - share articles and authors with your friends'
  end
  end
end