module SessionsHelper
  
  def login_message
  if @language == 2
    label = 'Sobald Sie angemeldet sind, können Sie: <br>
    - Autoren abonnieren<br>
    - Themen erstellen<br>
    - Artikel zur Leseliste speichern'
  else
    label = 'Once signed up, you can:<br>
    - subscribe to any author<br> 
    - create topics<br> 
    - save articles to your reading list'
  end
  end
end