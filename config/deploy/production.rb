require "rvm/capistrano"
default_run_options[:pty] = true
set :default_stage, "production"
role :app, linode_production
role :web, linode_production
role :db,  linode_production, :primary => true
set :use_sudo, false
set :rvm_type, :system
task :set_staging_flag, :roles => [:app] do
end
