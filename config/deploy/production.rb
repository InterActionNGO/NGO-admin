require "rvm/capistrano"
set :default_stage, "production"
role :app, linode_production
role :web, linode_production
set :use_sudo, false
role :db,  linode_production, :primary => true
set :rvm_type, :system
set :branch, fetch(:branch, "iati-refactor")
task :set_staging_flag, :roles => [:app] do
end
