module GroupsHelper
  def selection
    if @language == 2
        selection = 'Schlagzeilen' if params[:action] == 'index' && params[:controller] == 'groups'
        selection = 'Politik' if params[:action] == 'politics'
        selection = 'Feuilleton' if params[:action] == 'culture'
        selection = 'Wirtschaft' if params[:action] == 'business'
        selection = 'Wissen' if params[:action] == 'science'
        selection = 'Technik' if params[:action] == 'technology'
        selection = 'Vermischtes' if params[:action] == 'mixed'
        selection = 'Sport' if params[:action] == 'sport'
        selection = 'Meinungen' if params[:action] == 'opinions'
    else
        selection = 'Top stories' if params[:action] == 'index' && params[:controller] == 'groups'
        selection = 'Politics' if params[:action] == 'politics'
        selection = 'Culture' if params[:action] == 'culture'
        selection = 'Business' if params[:action] == 'business'
        selection = 'Science' if params[:action] == 'science'
        selection = 'Technology' if params[:action] == 'technology'
        selection = 'Mixed' if params[:action] == 'mixed'
        selection = 'Sport' if params[:action] == 'sport'
        selection = 'Opinions' if params[:action] == 'opinions'
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
        slogan = ' - automatisch generiert'
     else
       slogan = ' - automatically generated'
     end
   end
     


end
