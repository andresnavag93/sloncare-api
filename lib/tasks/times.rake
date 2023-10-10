namespace :times do

  task :server_payments => :environment do
    ModelMailer.send_contact_request(
      "anavarro@wayuinc.com", "Crontab AWS Recurring Payments", 
      Time.new, "es", "anavarro@wayuinc.com").deliver 
  end

  task :server_monthly => :environment do
    ModelMailer.send_contact_request(
      "anavarro@wayuinc.com", "Crontab AWS Monthly Maintenance", 
      Time.new, "es", "anavarro@wayuinc.com").deliver 
  end

  task :server_statistic => :environment do
    ModelMailer.send_contact_request(
      "anavarro@wayuinc.com", "Crontab AWS Plan Checks", 
      Time.new, "es", "anavarro@wayuinc.com").deliver 
  end

  task :server_cancelling => :environment do
    ModelMailer.send_contact_request(
      "anavarro@wayuinc.com", "Crontab AWS Cancelling Order", 
      Time.new, "es", "anavarro@wayuinc.com").deliver 
  end
end