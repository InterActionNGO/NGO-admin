set :default_stage, "production"

role :app, linode_production
role :web, linode_production
role :db,  linode_production, :primary => true

set :branch, "master"

task :set_staging_flag, :roles => [:app] do
end
