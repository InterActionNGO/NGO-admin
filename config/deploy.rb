require 'capistrano/ext/multistage'
require "bundler/capistrano"
set :whenever_environment, defer { stage }
set :whenever_identifier, defer { "#{application}_#{stage}" }
set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

# set :rvm_ruby_string, "ruby-1.8.7-p374"
set :use_sudo, false
set :stages, %w(staging production)

APP_CONFIG = YAML.load_file("config/app_config.yml")['production']

set :rollbar_token, APP_CONFIG['rollbar_token']
set(:rollbar_env) { stage }

set(:rails_env) { fetch(:stage) }

set :normalize_asset_timestamps, false

set :application, 'nam-admin'

set :scm, :git
# set :git_enable_submodules, 1
set :git_shallow_clone, 1
set :repository, "git@github.com:InterActionNGO/NGO-admin.git"
set :branch, "master"
set :ssh_options, {:forward_agent => true}
set :keep_releases, 5

# set :linode_production, '52.179.82.220'
# set :linode_staging, '66.228.36.71'
set :user,  'deploy'

set :deploy_to, "/var/www/#{application}"

after  "deploy:update_code", :symlinks, :asset_packages, :set_staging_flag
after "deploy:update", "deploy:cleanup"

desc "Uploads config yml files to app server's shared config folder"
task :upload_yml_files, :roles => :app do
  run "mkdir #{deploy_to}/shared/config ; true"
  upload("config/app_config.yml", "#{deploy_to}/shared/config/app_config.yml")
end

task :symlinks, :roles => [:app] do
  run <<-CMD
    ln -s #{shared_path}/config/app_config.yml #{release_path}/config/app_config.yml;
    ln -s #{shared_path}/node_modules #{release_path}/node_modules;
    ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml;
  CMD
end

desc 'Create asset packages'
task :asset_packages, :roles => [:app] do
  run "export RAILS_ENV=#{fetch :rails_env} && cd #{release_path} && npm install"
  run "export RAILS_ENV=#{fetch :rails_env} && cd #{release_path} && node_modules/.bin/bower install"
  run "export RAILS_ENV=#{fetch :rails_env} && cd #{release_path} && node_modules/.bin/grunt"
  run "export RAILS_ENV=#{fetch :rails_env} && cd #{release_path} && node_modules/.bin/grunt build"
end
