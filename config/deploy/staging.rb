set :application, "ngoaidmap-admin"
set :user, "deploy"
set :deploy_via, :remote_cache

set :default_environment, {
  'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/nvm/versions/node/v4.3.1/bin:$PATH'
}

set(:deploy_to)  { "/var/www/#{application}/#{rails_env}" }

set :shared_children, %w(public/system log tmp/pids public/uploads)

role :app, "198.199.86.239", :primary => true
role :web, "198.199.86.239"

server '198.199.86.239', :web, :app, :primary => true

task :set_staging_flag, :roles => [:app] do
  run <<-CMD
    cd #{release_path} &&
    touch STAGING
  CMD
end

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
end
