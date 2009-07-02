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

    author_ids               = subscriptions.collect{|s| s.author_id}.uniq*","

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
      user_stories       = user_subscriptions.collect{|s| rawstories_hashed[s.author_id].to_a[0,3]}.flatten
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
