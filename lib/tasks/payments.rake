namespace :payments do

  task :beneficiaries => :environment do
    time = Time.now
    month = time.month
    day = time.day

    beneficiaries = UserAccess.joins(:user).where(" 
       user_accesses.access_id = 69 AND
       EXTRACT(DAY FROM user_accesses.created_at) = ? AND 
       EXTRACT(MONTH FROM user_accesses.created_at) = ? AND 
       users.plan_id IS NOT NULL AND 
       users.saving_level_id IS NOT NULL AND
       users.customer_id IS NOT NULL", day, month)

    #beneficiaries = UserAccess.joins(:user).where("users.plan_id IS NOT NULL AND users.saving_level_id IS NOT NULL AND users.customer_id IS NOT NULL")

    for beneficiary in beneficiaries do
      user = beneficiary.user
      if user.saving_level_id
        if user.saving_level_id == 47
          if user.savings
            amount = user.savings
          else
            amount = user.saving_level.amount
          end
        else
          amount = user.saving_level.amount
        end
        begin
          locale = Gets::locale(user.locale_id)
          Posts::charge_recurring(user.customer_id, 'usd', amount, beneficiary.wallet, user.email, locale)
        rescue Exception => e
          puts e
          ModelMailer.send_recurring_payment_wallet( user.email, amount, beneficiary.wallet, locale, false).deliver
        end
      end
    end
    puts "#{Time.now} - All Beneficiary Recurring Payment Check!"  
  end
  
  task :groups => :environment do
    time = Time.now
    month = time.month
    day = time.day
    groups = Group.where(" 
      EXTRACT(DAY FROM created_at) = ? AND 
      EXTRACT(MONTH FROM created_at) = ? AND 
      customer_id IS NOT NULL AND 
      saving_level_id IS NOT NULL AND
      plan_id IS NOT NULL", day, month)
    #groups = Group.where("customer_id IS NOT NULL AND plan_id IS NOT NULL AND saving_level_id IS NOT NULL")

    for group in groups do
      count = group.group_beneficiaries.count
      if count > 0
        if group.saving_level_id
          if group.saving_level_id == 47
            if group.savings
              amount = group.savings
            else
              amount = group.saving_level.amount
            end
          else
            amount = group.saving_level.amount
          end
          begin
            locale = Gets::locale(group.locale_id)
            Posts::charge_recurring(group.customer_id, 'usd', amount, group.wallet, group.c_email, locale, count)
          rescue Exception => e
            puts e
            ModelMailer.send_recurring_payment_wallet( group.c_email, amount, group.wallet, locale, false).deliver
          end
        end
      end
    end
    puts "#{Time.now} - All Group Recurring Payment Check!"
  end
end