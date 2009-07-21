module HaufensHelper
 
  def haufen_preview_label haufen
     if @language == 2
       label = 'alle ' + haufen.weight.to_s + ' Artikel'
     else
       label = 'all ' + haufen.weight.to_s + ' articles'
     end

     return label
   end

   def video_preview_label haufen

    if haufen.videos > 1

      if @language == 2
        label = haufen.videos.to_s + ' Videos'
      else
        label = haufen.videos.to_s + ' videos'
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
 
 
 
 
  def haufens_label
    if @language == 2
      label = 'Ähnliche Artikel'
    else
      label = 'Related stories'
    end
    return label
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
    
  def show_videos_label videos_weight
      if @language == 2
        if videos_weight == 1
        label = '1 Video'
        else
        label = videos_weight.to_s + ' Videos'
        end
      else
        if videos_weight == 1
        label = '1 video'
        else
        label = videos_weight.to_s + ' videos'
        end
      end
      return label
      
  end

      
end
