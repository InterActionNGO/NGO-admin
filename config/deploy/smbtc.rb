set :default_stage, "smbtc"

role :app, linode_smbtc
role :web, linode_smbtc
role :db,  linode_smbtc, :primary => true

set :branch, "staging"

task :set_staging_flag, :roles => [:app] do
  run <<-CMD
    cd #{release_path} &&
    touch STAGING
  CMD
end
