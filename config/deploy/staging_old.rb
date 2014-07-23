set :default_stage, "staging"

role :app, linode_staging_old
role :web, linode_staging_old
role :db,  linode_staging_old, :primary => true

set :branch, "staging"

task :set_staging_flag, :roles => [:app] do
  run <<-CMD
    cd #{release_path} &&
    touch STAGING
  CMD
end
