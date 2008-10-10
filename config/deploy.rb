set :user, 'justus'
default_run_options[:pty] = true
set :scm, :git
set :scm_passphrase, "rosenwel" #This is your custom users password



#ssh_options[:forward_agent] = true
#ssh_options[:paranoid] = false
#ssh_options[:keys] = %w(/Users/ohlhaver/.ssh/id_rsa)
ssh_options[:port] = 2109

set :branch, "master"

set :application, "killerapp"
set :repository,  "git@github.com:ohlhaver/killerapp.git"

set :keep_releases, 3

set :deploy_via, :remote_cache

role :web, '74.63.8.37'
role :app, '74.63.8.37'
role :db,  '74.63.8.37', :primary => true


set :deploy_to, "/home/justus/#{application}"
set :use_sudo, false

set :mongrel_conf, "#{deploy_to}/current/config/mongrel_cluster.yml"

task :restart, :roles => :app do
end


task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public -R" 
end

task :after_deploy, :roles => [:web] do
    run "sed -e \"s/^# ENV/ENV/\" -i #{release_path}/config/environment.rb"
end

namespace :deploy do
  task :restart do
    run "mongrel_rails cluster::configure"
    run "mongrel_rails cluster::restart"
    
    #restart_mongrel_cluster
  end
end



