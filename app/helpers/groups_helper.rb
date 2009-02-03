module GroupsHelper
  def selection
    if @language == 2
        selection = 'Schlagzeilen des Tages' if params[:action] == 'index' && params[:controller] == 'groups'
        selection = 'Politik' if params[:action] == 'politics'
        selection = 'Feuilleton' if params[:action] == 'culture'
        selection = 'Wirtschaft' if params[:action] == 'business'
        selection = 'Wissen' if params[:action] == 'science'
        selection = 'Technik' if params[:action] == 'technology'
        selection = 'Vermischtes' if params[:action] == 'mixed'
        selection = 'Sport' if params[:action] == 'sport'
        selection = 'Autoren' if params[:action] == 'opinions'
    else
        selection = 'Today\'s top stories' if params[:action] == 'index' && params[:controller] == 'groups'
        selection = 'Politics' if params[:action] == 'politics'
        selection = 'Culture' if params[:action] == 'culture'
        selection = 'Business' if params[:action] == 'business'
        selection = 'Science' if params[:action] == 'science'
        selection = 'Technology' if params[:action] == 'technology'
        selection = 'Mixed' if params[:action] == 'mixed'
        selection = 'Sport' if params[:action] == 'sport'
        selection = 'Authors' if params[:action] == 'opinions'
   end
   #@selection = 'Ähnliche Artikel' if params[:controller] == 'haufens' && params[:action] == 'show'
   #@selection = 'Meinungen' if params[:controller] == 'haufens' && params[:action] == 'filter_haufen_by_opinions'
   return selection
   end

   def date
      t = Time.now
      m = t.mon
      if @language == 2
        month = 'Januar' if m == 1
        month = 'Februar' if m == 2
        month = 'März' if m == 3
        month = 'April' if m == 4
        month = 'Mai' if m == 5
        month = 'Juni' if m == 6
        month = 'Juli' if m == 7
        month = 'August' if m == 8
        month = 'September' if m == 9
        month = 'Oktober' if m == 10
        month = 'November' if m == 11
        month = 'Dezember' if m == 12

        #clock = t.strftime('%I:%M Uhr')
        day = t.mday.to_s

        date = ' - ' + day +'. ' + month #+ ' ' + clock
      else
         month = 'January' if m == 1
         month = 'February' if m == 2
         month = 'March' if m == 3
         month = 'April' if m == 4
         month = 'May' if m == 5
         month = 'June' if m == 6
         month = 'July' if m == 7
         month = 'August' if m == 8
         month = 'September' if m == 9
         month = 'October' if m == 10
         month = 'November' if m == 11
         month = 'December' if m == 12

        #clock = t.strftime('%I:%M Uhr')
         day = t.mday.to_s

          date = ' - ' + month + ' ' + day
        end
   end

   def slogan
     if @language == 2
        slogan = 'auto-generiert aus allen Zeitungen'
     else
       slogan = 'auto-generated from all newspapers'
     end
   end
   
   def ago
     last_update = Eintrag.find(:last).created_at
     if @language == 2

     label = 'vor 1 Minute' if ((Time.new - last_update).to_i) < 120
     label = 'vor ' + (((Time.new - last_update).to_i)/60).to_s + ' Minuten' if ((Time.new - last_update).to_i) > 119 && ((Time.new - last_update).to_i) < 3600 
     label = 'vor 1 Stunde' if ((Time.new - last_update).to_i) > 3599 && ((Time.new - last_update).to_i) < 7200
     label = 'vor ' + (((Time.new - last_update).to_i)/3600).to_s + ' Stunden' if ((Time.new - last_update).to_i) > 7199 && ((Time.new - last_update).to_i) < 86400 

     label = 'vor 1 Tag' if ((Time.new - last_update).to_i) > 86399 && ((Time.new - last_update).to_i) < 172800
     label = 'vor ' + (((Time.new - last_update).to_i)/86400).to_s + ' Tagen' if ((Time.new - last_update).to_i) > 172799 && ((Time.new - last_update).to_i) < 864000
     label = last_update.to_s(:long) if ((Time.new - last_update).to_i) > 863999

      else

        label = '1 minute ago' if ((Time.new - last_update).to_i) < 120
        label = (((Time.new - last_update).to_i)/60).to_s + ' minutes ago' if ((Time.new - last_update).to_i) > 119 && ((Time.new - last_update).to_i) < 3600 
        label = '1 hour ago' if ((Time.new - last_update).to_i) > 3599 && ((Time.new - last_update).to_i) < 7200
        label = (((Time.new - last_update).to_i)/3600).to_s + ' hours ago' if ((Time.new - last_update).to_i) > 7199 && ((Time.new - last_update).to_i) < 86400 

        label = '1 day ago' if ((Time.new - last_update).to_i) > 86399 && ((Time.new - last_update).to_i) < 172800
        label = (((Time.new - last_update).to_i)/86400).to_s + ' days ago' if ((Time.new - last_update).to_i) > 172799 && ((Time.new - last_update).to_i) < 864000
        label = last_update.to_s(:long) if ((Time.new - last_update).to_i) > 863999
     end



     return label
   end
     


end
