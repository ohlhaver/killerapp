module SessionsHelper
  
  def login_message
  if @language == 2
    label = 'Sobald Sie angemeldet sind, können Sie: <br><br>
    - eigene Themen erstellen<br>
    - Autoren abonnieren<br>
    - Artikel zur Leseliste speichern<br>'
  else
    label = 'Once signed up, you can:<br><br>
    - create your own topics<br>
    - subscribe to any author<br>      
    - save articles to your reading list<br>'
  end
  end
end