set :default_stage, "smbtc"

role :app, smbtc
role :web, smbtc
role :db,  smbtc, :primary => true

set :branch, "staging"

task :set_staging_flag, :roles => [:app] do
end
