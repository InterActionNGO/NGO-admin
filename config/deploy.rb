require 'capistrano/ext/multistage'
require 'config/boot'
require "bundler/capistrano"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :use_sudo, false
set :stages, %w(staging production smbtc)

APP_CONFIG = YAML.load_file("config/app_config.yml")['production']

set :rollbar_token, APP_CONFIG['rollbar_token']
set(:rollbar_env) { stage }

set :normalize_asset_timestamps, false

default_run_options[:pty] = true

set :application, 'ngo-admin'

set :scm, :git
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :scm_user, 'ubuntu'
set :repository, "git://github.com/simbiotica/iom.git"
set :branch, "iati-refactor"
ssh_options[:forward_agent] = true
set :keep_releases, 5

# set :linode_staging_old, '178.79.131.104'
# set :linode_production_old, '173.255.238.86'
set :linode_production, '23.92.20.76'
set :linode_staging, '66.228.36.71'
set :user,  'ubuntu'

set :deploy_to, "/home/ubuntu/www/#{application}"

after  "deploy:update_code", :symlinks, :run_migrations, :asset_packages, :set_staging_flag
after "deploy:update", "deploy:cleanup"

desc "Restart Application"
deploy.task :restart, :roles => [:app] do
  run "touch #{current_path}/tmp/restart.txt"
  run "#{sudo} /etc/init.d/memcached force-reload"
end

desc "Migrations"
task :run_migrations, :roles => [:app] do
  run <<-CMD
    export RAILS_ENV=production &&
    cd #{release_path} &&
    bundle exec rake db:migrate
  CMD
end

desc "Uploads config yml files to app server's shared config folder"
task :upload_yml_files, :roles => :app do
  run "mkdir #{deploy_to}/shared/config ; true"
  upload("config/app_config.yml", "#{deploy_to}/shared/config/app_config.yml")
end

task :symlinks, :roles => [:app] do
  run <<-CMD
    ln -s #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml;
    ln -s #{shared_path}/node_modules #{release_path}/node_modules;
    ln -s #{shared_path}/public/app/vendor #{release_path}/public/app/vendor;
  CMD
end

desc 'Create asset packages'
task :asset_packages, :roles => [:app] do
 # run <<-CMD
 #   export RAILS_ENV=production &&
 #   cd #{release_path} &&
 #   npm install &&
 #   bower install &&
 #   grunt build
 # CMD
end
