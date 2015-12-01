require "rvm/capistrano"
set :default_stage, "smbtc"
set :rvm_type, :system

set :use_sudo, false

role :app, linode_staging
role :web, linode_staging
role :db,  linode_staging, :primary => true

set :branch, fetch(:branch, "iati-refactor")

task :set_staging_flag, :roles => [:app] do
  run <<-CMD
    cd #{release_path} &&
    touch STAGING
  CMD
end
