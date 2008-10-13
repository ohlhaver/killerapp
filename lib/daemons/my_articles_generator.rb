#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do

  
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

  
  sleep 900
end