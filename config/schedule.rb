# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 1.minutes do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever


set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

# every 5.minutes do
# every 1.minutes do
#   rake "payments:times", :environment => 'development'
# end

#every 1.minutes, :roles => [:leader] do
# command "touch $EB_CONFIG_APP_SUPPORT/.cron_check"
#end

# every 5.minutes, :roles => [:leader] do
#   rake "times:server", :environment => 'development'
# end

#CRONTAB
#Recurring Payments
every 1.days, :at => '10:00 pm' do
rake "payments:beneficiaries", :environment => 'production'
rake "payments:groups", :environment => 'production'
#rake "times:server_payments", :environment => 'production'
end

#View Statistics Plans
every 1.days, :at => '11:59 pm' do
rake "statistics:beneficiaries", :environment => 'production'
rake "statistics:groups", :environment => 'production'
#rake "times:server_statistic", :environment => 'production'
end

#Order Cancelling
every 1.days, :at => '11:00 pm' do
rake "service_orders:cancelling", :environment => 'production'
#rake "times:server_cancelling", :environment => 'production'
end

#Mantainning Check
every 1.days, :at => '10:30 pm' do
rake "maintenances:monthly_wallet", :environment => 'production'
end