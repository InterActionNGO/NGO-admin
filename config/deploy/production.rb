#require "rvm/capistrano"
set :default_stage, "production"
role :app, linode_production
role :web, linode_production
role :db,  linode_production, :primary => true
set :use_sudo, false
#set :rvm_type, :system
set :branch, fetch(:branch, "iati-refactor")
task :set_staging_flag, :roles => [:app] do
end
