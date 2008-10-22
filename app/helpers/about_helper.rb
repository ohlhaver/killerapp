module AboutHelper
  
  def feedback_question
  if @language == 2
    label = 'Bitte nennen Sie uns Ihre Ideen und Fragen! '
  else
    label = 'Please tell us your ideas and questions!'
  end
  end

  def feedback_button
    if @language == 2
      label = 'Absenden'
    else
      label = 'send'
    end
  end

end
