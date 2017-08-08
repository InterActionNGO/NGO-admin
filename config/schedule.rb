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
every 1.day, :at => '8:00 am' do
  rake "iom:visits:update"
end

every 1.day :at => '8:00 pm' do
   rake "iom:iati:sync" 
end

every 'Tuesday', :at => '4PM' do
  rake "iom:alerts:projects_about_to_end"
  rake "iom:alerts:six_months_since_last_login"
end
