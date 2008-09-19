# create new file config/initializers/mail.rb
 
require "smtp_tls"
 
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com",
:port => 587,
:authentication => :plain,
:user_name => "jurnalo.user.service@googlemail.com",
:password => 'howardhughes'}