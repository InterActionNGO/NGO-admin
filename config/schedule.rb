# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
job_type :rake, ". $HOME/.env; cd :path && :environment_variable=:environment :bundle_command rake :task --silent :output"
set :bundle_command, "/home/deploy/.rbenv/versions/1.8.7-p374/bin/bundle exec"
set :output, { :error => '/var/www/shared/cron.front.error.log', :standard => '/var/www/shared/cron.front.log' }

every 1.day, :at => '8:00 am' do
  rake "iom:visits:update"
end

every 1.day, :at => '6:00 am' do
   rake "iom:iati:sync" 
end

every 'Tuesday', :at => '2:50PM' do
  rake "iom:alerts:projects_about_to_end"
  rake "iom:alerts:six_months_since_last_login"
end
