#!/usr/bin/env ruby
require File.dirname(__FILE__) + "/../../config/environment"
require 'cache_utils'
$running = true

Signal.trap("TERM") do 
  $running = false
end

while($running) do
  Eintrag.create(:name => 'cache updator started')   
  starting_time = Time.new
  
  # update home page cache for users
  User.find(:all,:order =>"id ASC").each do |u|
    fb_user = u.fb_user(true) rescue nil
    jurnalo_friends = u.jurnalo_friends(true) rescue []
    CacheUtils::GroupsControllerCache.new.update_cache_index(u) rescue nil
    CacheUtils::UsersControllerCache.new.update_cache_articles_by_favorite_authors(u) rescue nil
  end

  finishing_time = Time.new
  duration = (finishing_time - starting_time)
  Eintrag.create(:name => 'cache updator completed', :duration => duration)
  time_left  = 500 - duration
  if time_left > 0
    sleep time_left
  end
end
