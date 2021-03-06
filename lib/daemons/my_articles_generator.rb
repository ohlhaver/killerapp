#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"
require 'logger'
#############################################################################
# Important : ExceptionNotifiable works inside of a controller
#             We will have to find a way of notifying exceptions from daemons
#
# TODO : we will visit it in the future. 
#        As of now only concentrating on loggin and performance improvement
#############################################################################
#include ExceptionNotifiable

##################################################
#  Start : Functions and Variables for Loggin    
##################################################

$log = Logger.new("#{File.dirname(__FILE__)}/../../log/daemon_my_articles_generator.log") 
def log_message(mes, message_type=nil)
  case message_type
  when 'info'
    $log.info "#{Time.now} : #{mes}"
  when 'warn'
    $log.warn "#{Time.now} : #{mes}"
  when 'debug'
    $log.debug "#{Time.now} : #{mes}"
  when 'error'
    $log.error "#{Time.now} : #{mes}"
  when 'fatal'
    $log.fatal "#{Time.now} : #{mes}"
  else
    $log.info "#{Time.now} : #{mes}"
  end
end
##################################################
#  End : Functions and Variables for Loggin      
##################################################


$running = true

Signal.trap("TERM") do 
  $running = false
  log_message("Daemon Killed")
end

log_message("Daemon Started")

while($running) do
  
  begin
    Eintrag.create(:name => 'my articles generating started')   
    log_message("my articles generating started")
    starting_time = Time.new
   
    # my articles computation 
    # Speeding up requires the following :
    #  Addubg index to author_id column of rawstories table
    #  Adding indexes to columns user_id, author_id in table subscriptions
    
    # Find all the subscriptions
    all_subscriptions        = Subscription.find(:all,
                                                 :order  => "created_at DESC",
                                                 :select => "user_id, author_id")
    all_subscriptions_hashed = all_subscriptions.group_by{|s| s.user_id}

    # Find all the users who have subscribed to at least one author
    user_ids                 = all_subscriptions.collect{|s| s.user_id}.uniq*","
    all_users                = user_ids.blank? ? [] : User.find(:all,
                                                                :conditions => ["id IN ( #{user_ids})"])


    # Find all the new rawstories corresponding to all the subscribed authors
      # Get  all unique authors
      s_author_ids               = all_subscriptions.collect{|s| s.author_id}.uniq*","
      authors                    = Author.find(:all, :conditions => "id IN ( #{s_author_ids} )" )
      authors_hashed             = authors.group_by{|a| a.id}
      unapproved_authors = []
      approved_authors   = []
      authors.each do |a|
          if a.approved?
            approved_authors << a
          else
            unapproved_authors << a
          end
      end
      unique_author_ids = approved_authors.collect{|a| a.approved_map.unique_author_id}.uniq*','
      all_author_maps = AuthorMap.find(:all, 
                                :conditions => ["unique_author_id IN ( #{unique_author_ids}) and status = :approved",
                                                {:unique_author_id => unique_author_ids, 
                                                 :approved => JConst::AuthorMapStatus::APPROVED}],
                                :select => 'author_id,unique_author_id')
      all_author_maps_hashed = all_author_maps.group_by{|a| a.unique_author_id}
      all_author_ids = all_author_maps.collect{|a| a.author_id}
      author_ids               = (unapproved_authors.collect{|a| a.id} + all_author_ids).uniq*','
    #
    time_now = Time.now
    rawstories               = author_ids.blank? ? [] :  Rawstory.find(:all,
                                                                       :conditions => "author_id IN ( #{author_ids} )",
                                                                       :order      => "id DESC",
                                                                       :select     => "id, author_id, title, link")
    rawstories_hashed        = rawstories.group_by{|r| r.author_id}

   # Update stories, new_stories columns for  users without subscriptions
    User.update_all("stories = '', new_stories = '' ", "id NOT IN  ( #{user_ids})")


   # Update stories, new_stories columns for  users with at least one subscription
    all_users.each do |user|
        old_user_stories = user.stories.split(' ')
        user_stories = ''
        new_user_stories = ''
        new_user_stories_a = []
        subscriptions = all_subscriptions_hashed[user.id].to_a
        subscriptions.each do |subscription|
            a = authors_hashed[subscription.author_id].to_a.first
            unless a.approved?
              author_stories = rawstories_hashed[subscription.author_id].to_a[0,3]
            else
              author_stories = []
              all_author_ids = (all_author_maps_hashed[a.group_primary_author_id].to_a + [a.id]).uniq
              all_author_ids.each do |a_id|
                author_stories += rawstories_hashed[a_id].to_a
              end
              author_stories = author_stories.sort_by{|s|  s.id}.reverse[0,3]
            end
            author_stories.each do |story|
                story_id = story.id.to_s
                unless old_user_stories.include?(story_id)
                  new_user_stories += story_id + ' ' 
                  new_user_stories_a << story
                end
                user_stories += story_id + ' '
            end
        end
        user.stories = user_stories
        user.new_stories = new_user_stories
        if user.alert_type == User::Alert::IMMEDIATE 
          user.send_alerts(new_user_stories_a) 
          user.last_alert_at = time_now
        end
        user.save!
    end


    finishing_time = Time.new
    duration = (finishing_time - starting_time)
    Eintrag.create(:name => 'my articles generating completed', :duration => duration)
    log_message("my articles generating completed, duration = #{duration}")
    sleep 900
  rescue Exception => e
    $running = false
    if e.class == Interrupt
      log_message("Daemon terminated.")
    else
      log_message("Error while generating my articles. Stoping the daemon......\nerror = #{e.inspect}", 'error')
    end 
  end
end
