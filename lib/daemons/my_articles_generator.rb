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
      user_stories = ''
      authors = user.authors
      authors.each do |author|
          author_stories = author.rawstories.last(3)
          author_stories.each do |story|
              user_stories += story.id.to_s + ' '
          end
      end
      user.stories = user_stories
      user.save
  end
  finishing_time = Time.new
  duration = (finishing_time - starting_time)
  Eintrag.create(:name => 'my articles generating completed', :duration => duration)

  
  sleep 600
end