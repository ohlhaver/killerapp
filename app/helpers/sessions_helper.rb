module SessionsHelper
  
  def login_message
  if @language == 2
    label = 'Sobald Sie angemeldet sind, können Sie eigene Lieblingsautoren und Themen erstellen.'
  else
    label = 'Once signed up, you can create your favourite authors and topics.'
  end
  end
end