set :default_stage, "smbtc"

role :app, smbtc
role :web, smbtc
role :db,  smbtc, :primary => true

set :branch, "staging"

task :set_staging_flag, :roles => [:app] do
  run <<-CMD
    cd #{release_path} &&
    touch STAGING
  CMD
end
