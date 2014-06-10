set :default_stage, "production_old"

role :app, linode_production_old
role :web, linode_production_old
role :db,  linode_production_old, :primary => true

set :branch, "production"

task :set_staging_flag, :roles => [:app] do
end
