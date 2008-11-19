module RawstoriesHelper
 def peterson rawstory
   
   if @language == 2
   
   label = 'vor 1 Minute' if ((Time.new - rawstory.created_at).to_i) < 120
   label = 'vor ' + (((Time.new - rawstory.created_at).to_i)/60).to_s + ' Minuten' if ((Time.new - rawstory.created_at).to_i) > 119 && ((Time.new - rawstory.created_at).to_i) < 3600 
   label = 'vor 1 Stunde' if ((Time.new - rawstory.created_at).to_i) > 3599 && ((Time.new - rawstory.created_at).to_i) < 7200
   label = 'vor ' + (((Time.new - rawstory.created_at).to_i)/3600).to_s + ' Stunden' if ((Time.new - rawstory.created_at).to_i) > 7199 && ((Time.new - rawstory.created_at).to_i) < 86400 

   label = 'vor 1 Tag' if ((Time.new - rawstory.created_at).to_i) > 86399 && ((Time.new - rawstory.created_at).to_i) < 172800
   label = 'vor ' + (((Time.new - rawstory.created_at).to_i)/86400).to_s + ' Tagen' if ((Time.new - rawstory.created_at).to_i) > 172799 && ((Time.new - rawstory.created_at).to_i) < 864000
   label = rawstory.created_at.to_s(:long) if ((Time.new - rawstory.created_at).to_i) > 863999
   
    else
   
      label = '1 minute ago' if ((Time.new - rawstory.created_at).to_i) < 120
      label = (((Time.new - rawstory.created_at).to_i)/60).to_s + ' minutes ago' if ((Time.new - rawstory.created_at).to_i) > 119 && ((Time.new - rawstory.created_at).to_i) < 3600 
      label = '1 hour ago' if ((Time.new - rawstory.created_at).to_i) > 3599 && ((Time.new - rawstory.created_at).to_i) < 7200
      label = (((Time.new - rawstory.created_at).to_i)/3600).to_s + ' hours ago' if ((Time.new - rawstory.created_at).to_i) > 7199 && ((Time.new - rawstory.created_at).to_i) < 86400 

      label = '1 day ago' if ((Time.new - rawstory.created_at).to_i) > 86399 && ((Time.new - rawstory.created_at).to_i) < 172800
      label = (((Time.new - rawstory.created_at).to_i)/86400).to_s + ' days ago' if ((Time.new - rawstory.created_at).to_i) > 172799 && ((Time.new - rawstory.created_at).to_i) < 864000
      label = rawstory.created_at.to_s(:long) if ((Time.new - rawstory.created_at).to_i) > 863999
   end
   
   
   
   return label
 end
 
 def haufen_label rawstory
    if @language == 2
      label = 'alle ' + rawstory.haufen.weight.to_s + ' Artikel'
    else
      label = 'all ' + rawstory.haufen.weight.to_s + ' articles'
    end
 
    return label
  end
  
  def video_label rawstory
     
   if rawstory.haufen.videos > 1
     
     if @language == 2
       label = rawstory.haufen.videos.to_s + ' Videos'
     else
       label = rawstory.haufen.videos.to_s + ' videos'
     end
    else
      if @language == 2
         label = '1 Video'
       else
         label = '1 video'
       end
      end
      
      

     return label
   end
  
  
  
  def opinion_label
    if @language == 2
      label = '(Meinung)' 
    else
      label = '(opinion)'
    end
  end
  
  def show_all_label
    if @language == 2
      label = 'alle'
    else
      label = 'all'
    end
    return label
  end
  
  
  def show_opinions_label opinion_weight
      if @language == 2
        if opinion_weight == 1
        label = '1 Meinung'
        else
        label = opinion_weight.to_s + ' Meinungen'
        end
      else
        if opinion_weight == 1
        label = '1 opinion'
        else
        label = opinion_weight.to_s + ' opinions'
        end
      end
      return label   
  end
  
  def opinion_results
    if @language == 2
      label = 'Meinungen zu ' 
    else
      label = 'Opinions on '
    end
    return label
  end
  
  def search_results
    if @language == 2
      label = 'Suchergebnisse für '
    else
      label = 'Search results for '
    end
    return label
  end
  
end
