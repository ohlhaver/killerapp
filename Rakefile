# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

namespace :email_alerts do
  task :send_daily_alerts do
    require(File.join(File.dirname(__FILE__), 'lib', 'daemons', 'email_alerts.rb'))
    EmailAlerts.new.send_email_alerts('daily')
  end

  task :send_weekly_alerts do
    require(File.join(File.dirname(__FILE__), 'lib', 'daemons', 'email_alerts.rb'))
    EmailAlerts.new.send_email_alerts('weekly')
  end

end
