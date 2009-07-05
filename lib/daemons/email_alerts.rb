#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/environment"
require 'logger'
$log = Logger.new("#{File.dirname(__FILE__)}/../../log/daemon_email_alerts.log") 

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

class EmailAlerts

  def send_email_alerts(schedule='daily')
    Eintrag.create(:name => 'email alerts sending started')   
    log_message("email alerts sending started")
    starting_time = Time.new

    users = User.find(:all)
    if schedule == 'daily'
       users = users.find_all{|u| u.alert_type == User::Alert::DAILY}
    elsif schedule == 'weekly'
       users = users.find_all{|u| u.alert_type == User::Alert::WEEKLY}
    elsif schedule == 'immediate'
       users = users.find_all{|u| u.alert_type == User::Alert::IMMEDIATE}
    else 
       users = []
    end
    return if users.blank?

    user_ids                 = users.collect{|u| u.id}.uniq*","
    
    subscriptions            = Subscription.find(:all,
                                                 :conditions => ["user_id IN ( #{user_ids} )"],
                                                 :order  => "created_at DESC",
                                                 :select => "user_id, author_id")
    subscriptions_hashed     = subscriptions.group_by{|s| s.user_id}
    # Find all the new rawstories corresponding to all the subscribed authors
      # Get  all unique authors
      s_author_ids               = subscriptions.collect{|s| s.author_id}.uniq*","
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

    time_now                 = Time.now
    last_time_alerts         = (schedule == 'daily')? time_now - 1.day : time_now - 1.week
    rawstories               = author_ids.blank? ? [] :  Rawstory.find(:all,
                                                                       :conditions => ["author_id IN ( #{author_ids} ) and created_at > ?",last_time_alerts],
                                                                       :order      => "id DESC",
                                                                       :select     => "id, author_id, title, link")
    rawstories_hashed        = rawstories.group_by{|r| r.author_id}

    # Update stories, new_stories columns for  users with at least one subscription
    users.each do |user|
      user_subscriptions = subscriptions_hashed[user.id].to_a
      user_stories       =  [] 
      user_subscriptions.each do |subscription|
        a = authors_hashed[subscription.author_id].to_a.first
        author_stories = []
        unless a.approved?
          author_stories = rawstories_hashed[subscription.author_id].to_a[0,3]
        else
          all_author_ids = (all_author_maps_hashed[a.group_primary_author_id].to_a + [a.id]).uniq
          all_author_ids.each do |a_id|
            author_stories += rawstories_hashed[a_id].to_a
          end
          author_stories = author_stories.sort_by{|s|  s.id}.reverse[0,3]
        end
        user_stories += author_stories
      end
      #collect{|s| rawstories_hashed[s.author_id].to_a[0,3]}.flatten
      user.send_alerts(user_stories)
      user.last_alert_at = time_now
      user.new_stories = nil
      user.save!
    end

    finishing_time = Time.new
    duration = (finishing_time - starting_time)
    Eintrag.create(:name => 'email alerts sending completed', :duration => duration)
    log_message("email alerts sending completed, duration = #{duration}")
  end
end
