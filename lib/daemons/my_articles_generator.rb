#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"
include ExceptionNotifiable
$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
 
  Eintrag.create(:name => 'my articles generating started')   
  starting_time = Time.new
  
  all_users = User.find(:all)
  all_users.each do |user|
      old_user_stories = user.stories
      user_stories = ''
      new_user_stories = ''
      authors = user.authors
      authors.each do |author|
          author_stories = author.rawstories.last(3)
          author_stories.each do |story|
              story_id = story.id.to_s
              new_user_stories += story_id + ' ' unless old_user_stories.match(story_id)
              user_stories += story_id + ' '
              
          end
      end
      user.stories = user_stories
      user.new_stories = new_user_stories
      user.save
  end
  finishing_time = Time.new
  duration = (finishing_time - starting_time)
  Eintrag.create(:name => 'my articles generating completed', :duration => duration)




  
  sleep 900
end