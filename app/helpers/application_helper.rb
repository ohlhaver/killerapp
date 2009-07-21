# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title_label
    if params[:controller] == 'authors' and params[:action] == 'show'
      if @language ==2
          label= 'Artikel von ' + @author.name + ' - Jurnalo'  
        else
          label= 'Articles by ' + @author.name + ' - Jurnalo' 
      end
      
      
    elsif	params[:controller] == 'groups' and params[:action] == 'index'
  	  if @language ==2
          label = 'Jurnalo - die besten Artikel zu den wichtigsten Nachrichten des Tages' 
        else
          label = 'Jurnalo - the best articles on today\'s most important news' 
      end
      
      elsif params[:controller] == 'groups' and params[:action] == 'politics'
         if @language ==2
             label= 'Politik ' + ' - Jurnalo'  
           else
             label= 'Politics ' + ' - Jurnalo' 
         end
         
         elsif params[:controller] == 'groups' and params[:action] == 'culture'
            if @language ==2
                label= 'Feuilleton ' + ' - Jurnalo'  
              else
                label= 'Culture ' + ' - Jurnalo' 
            end
            
            elsif params[:controller] == 'groups' and params[:action] == 'business'
               if @language ==2
                   label= 'Wirtschaft ' + ' - Jurnalo'  
                 else
                   label= 'Business ' + ' - Jurnalo' 
               end
               
               elsif params[:controller] == 'groups' and params[:action] == 'science'
                  if @language ==2
                      label= 'Wissenschaft ' + ' - Jurnalo'  
                    else
                      label= 'Science ' + ' - Jurnalo' 
                  end
                  
                  elsif params[:controller] == 'groups' and params[:action] == 'technology'
                     if @language ==2
                         label= 'Technik ' + ' - Jurnalo'  
                       else
                         label= 'Technology ' + ' - Jurnalo' 
                     end
                     
                     elsif params[:controller] == 'groups' and params[:action] == 'sport'
                        if @language ==2
                            label= 'Sport ' + ' - Jurnalo'  
                          else
                            label= 'Sport ' + ' - Jurnalo' 
                        end
                        
                        elsif params[:controller] == 'groups' and params[:action] == 'mixed'
                           if @language ==2
                               label= 'Vermischtes ' + ' - Jurnalo'  
                             else
                               label= 'Mixed ' + ' - Jurnalo' 
                           end
                         
                         elsif params[:controller] == 'groups' and params[:action] == 'opinions'
                            if @language ==2
                                label= 'Meinungen ' + ' - Jurnalo'  
                              else
                                label= 'Opinions ' + ' - Jurnalo' 
                            end
                            
                            elsif params[:controller] == 'subscriptions' 
                               if @language ==2
                                   label= 'Meine Autoren ' + ' - Jurnalo'  
                                 else
                                   label= 'My authors ' + ' - Jurnalo' 
                               end
                               
                               elsif params[:action] == 'articles_by_favorite_authors' 
                                  if @language ==2
                                      label= 'Meine Autoren ' + ' - Jurnalo'  
                                    else
                                      label= 'My authors ' + ' - Jurnalo' 
                                  end
                               
                               
                               elsif params[:controller] == 'read_list' 
                                  if @language ==2
                                      label= 'Leseliste ' + ' - Jurnalo'  
                                    else
                                      label= 'Reading list ' + ' - Jurnalo' 
                                  end
         
                                elsif params[:action] == 'settings' 
                                   if @language ==2
                                       label= 'Einstellungen ' + ' - Jurnalo'  
                                     else
                                       label= 'Settings ' + ' - Jurnalo' 
                                   end
                                   
                                   elsif params[:controller] == 'sessions' and params[:action] == 'new'
                                      if @language ==2
                                          label= 'Einloggen ' + ' - Jurnalo'  
                                        else
                                          label= 'Login ' + ' - Jurnalo' 
                                      end
                                      
                                      elsif params[:controller] == 'users' and params[:action] == 'new'
                                         if @language ==2
                                             label= 'Registrieren ' + ' - Jurnalo'  
                                           else
                                             label= 'Sign up ' + ' - Jurnalo' 
                                         end
                                         
                                       elsif params[:controller] == 'rawstories' and params[:action] == 'search'
                                          if @language ==2
                                              label= h(params[:q]) + ' - Jurnalo'  
                                            else
                                              label= h(params[:q]) + ' - Jurnalo' 
                                          end
                                          
                                          elsif params[:controller] == 'rawstories' and params[:action] == 'filter_by_opinions'
                                             if @language ==2
                                                 label= 'Meinungen zu ' + h(params[:q]) + ' - Jurnalo'  
                                               else
                                                 label= 'Opinions on ' + h(params[:q]) + ' - Jurnalo' 
                                             end
                                             
                                             elsif params[:controller] == 'rawstories' and params[:action] == 'filter_by_videos'
                                                if @language ==2
                                                    label= 'Videos zu ' + h(params[:q]) + ' - Jurnalo'  
                                                  else
                                                    label= 'Videos on ' + h(params[:q]) + ' - Jurnalo' 
                                                end
                                             
                                             
                                             
                                             
                                             
    
    else
    label = 'Jurnalo'
    end
      
    
    return label
  end
  
  
  def add_to_my_authors_label
    if @language ==2
      label = 'abonnieren' 
    else
      label = 'subscribe' 
    end
    return label
  end

  def remove_from_my_authors_label
    if @language ==2
      label = 'abbestellen' 
    else
      label = 'unsubscribe' 
    end
    return label
  end

  def via_jurnalo_label
   " (found via www.jurnalo.#{@l == 'd' ? 'de' : 'com'})"
  end
  def invite_label
    if @language ==2
      label = 'einladen' 
    else
      label = 'invite'
    end
    return label
  end
  def list_of_friends_label
    if @language ==2
      label = 'Liste der Freunde' 
    else
      label = 'list of friends'
    end
    return label

  end
  def recommendation_label
    if @language ==2
      label = 'Empfehlungen' 
    else
      label = 'Recommendations'
    end
    return label
  end
  def share_label
    if @language ==2
      label = 'empfehlen' 
    else
      label = 'share'
    end
    return label
  end
  def recommend_label
    if @language ==2
      label = 'empfehlen' 
    else
      label = 'recommend'
    end
    return label
  end

  def actions_label
    if @language ==2
      label = 'Aktionen' 
    else
      label = 'Actions'
    end
    return label
  end
  def notifications_label
    if @language ==2
      label = 'Benachrichtigungen' 
    else
      label = 'Notifications'
    end
    return label
  end

  
  def profile_label
    if @language ==2
      label = 'Profil' 
    else
      label = 'Profile'
    end
    return label
  end
  def friends_label
    if @language ==2
      label = 'Freunde' 
    else
      label = 'Friends'
    end
    return label
  end

  def authors_label
    if @language ==2
      label = 'Autoren' 
    else
      label = 'Authors'
    end
    return label
  end

  def sign_up_label
    if @language ==2
      label = 'Registrieren' 
    else
      label = 'Sign up'
    end
    return label
  end
  def facebook_login_button(message=nil,style=nil)
   message ||= "Connect with Facebook" if @language == 1
   message ||= "Mit Facebook verbinden" if @language == 2
   style   ||= "vertical-align:-7px;"
   code = <<-EOF
   <span style="#{style}">
   #{facebook_login_only_button( {:size => :small,:length => :short, :background => :white})}
   </span>
   <span>#{facebook_login_only_link message}</span>
   EOF
  end
  def facebook_login_only_button(property_hash)
    fb_login_button "window.location='/users/link_user_accounts?l=#{@l}';", property_hash
  end
  def facebook_login_only_link(message)
   link_html = <<-EOF
    <a href="#" onclick="FB.Connect.requireSession(function(){window.location='/users/link_user_accounts?l=#{@l}';});return false;" >#{message}</a>
   EOF
   link_html
  end

  def duplicates_label
    if @language ==2
      label = 'Duplikate anzeigen' 
    else
      label = 'show duplicates'
    end
    
    return label

  end
  def articles_list_label
    if @language ==2
      label = 'Artikel'
    else
      label = 'Articles' 
    end
    
    return label
  end

   def search_label
     
      if @language ==2
      label = 'suche Nachrichten'
      else
      label = 'search news' 
      end
    
    return label
  end
  
   def settings_label
     
      if @language ==2
      label = 'Einstellungen'
      else
      label = 'Settings' 
      end
    
    return label
  end
  
  def read_list_label
    if @language == 2
      'Leseliste'
    else
      'Reading list'
    end
  end

  def save_to_read_list_label
   if @language == 2
     'zur Leseliste hinzufügen'
   else
     'add to reading list'
   end
  end

  def remove_from_read_list_label
   if @language == 2
     'von der Leseliste entfernen'
   else
     'remove from reading list'
   end
  end

  
  
  def previous_label
    if @language ==2
    label = 'zurück'
    else
    label = 'previous' 
    end
    
    return label
  end
  
  def next_label
    if @language ==2
    label = 'vorwärts'
    else
    label = 'next' 
    end
    
    return label
  end
  
  
  def my_authors
    if @language ==2
      label = 'Meine Autoren'
    else
      label = 'My authors'
    end
  end
  def login_label
    if @language ==2
      label = 'Einloggen'
    else
      label = 'Login'
    end
  end
  def logout_label
    if @language ==2
      label = '(ausloggen)'
    else
      label = '(logout)'
    end
  end
  
  def topstories_label
    if @language ==2
      label = 'Home'
    else
      label = 'Home'
    end
  end
  def politics_label
    if @language ==2
      label = 'Politik'
    else
      label = 'Politics'
    end
  end
  def business_label
    if @language ==2
      label = 'Wirtschaft'
    else
      label = 'Business'
    end
  end
  def culture_label
    if @language ==2
      label = 'Feuilleton'
    else
      label = 'Culture'
    end
  end
  def science_label
    if @language ==2
      label = 'Wissen'
    else
      label = 'Science'
    end
  end
  def technology_label
    if @language ==2
      label = 'Technik'
    else
      label = 'Technology'
    end
  end
  def sport_label
    if @language ==2
      label = 'Sport'
    else
      label = 'Sport'
    end
  end
  def mixed_label
    if @language ==2
      label = 'Vermischtes'
    else
      label = 'Mixed'
    end
  end
  def opinions_label
    if @language ==2
      label = 'Meinungen'
    else
      label = 'Opinions'
    end
  end 
  
  
  def topics_label
    if @language ==2
      label = 'Meine Themen'
    else
      label = 'My topics'
    end
  end
  
  
  def imprint_label
    if @language ==2
      label = 'Impressum'
    else
      label = 'About'
    end
  end
  
  def privacy_label
    if @language ==2
      label = 'Datenschutz'
    else
      label = 'Privacy'
    end
  end
  
  def subscribe_label
    if @language ==2
      label = '(anmelden)'
    else
      label = '(subscribe)'
    end
  end
  
  def unsubscribe_label
    if @language ==2
      label = '(abmelden)'
    else
      label = '(unsubscribe)'
    end
  end
  
  def create_topic
    if @language ==2
      label = 'Neues Thema'
    else
      label = 'New topic'
    end
  end
  
  
 
end
