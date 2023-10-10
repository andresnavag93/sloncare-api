namespace :statistics do
  
  task :beneficiaries => :environment do
    time = Time.now
    day = time.day
    time_custom = time - 2.months

    beneficiaries = UserAccess.joins(:user).where(" 
       user_accesses.access_id = 69 AND
       EXTRACT(DAY FROM user_accesses.created_at) = ? AND 
       user_accesses.created_at <= ? AND 
       users.plan_id IS NOT NULL AND users.saving_level_id IS NOT NULL", day, time_custom)

    # beneficiaries = UserAccess.joins(:user).where("
    #   user_accesses.created_at <= ? AND 
    #   user_accesses.access_id = 69 AND
    #   users.plan_id IS NOT NULL AND 
    #   users.saving_level_id IS NOT NULL", Time.now)


    for beneficiary in beneficiaries do
      months = (time.year * 12 + time.month) - (beneficiary.created_at.year * 12 + beneficiary.created_at.month)
      begin
        #avg = beneficiary.wallet.transacs.sum(:amount)/months
        avg = Transac.where("pay_wallet_id = ? AND transac_type_id = 119", beneficiary.wallet.id).sum(:amount)/months
        if avg.nan? or avg.nil?
          avg = 0
        end
        puts avg
      rescue
        avg = 0
      end
      if 0 <= avg && avg < 20
        saving_level = 43
        savings = 10
      elsif 20 <= avg && avg < 30
        saving_level = 44
        savings = 20
      elsif 30 <= avg && avg < 40
        saving_level = 45
        savings = 30
      elsif 40 <= avg && avg < 50
        saving_level = 46
        savings = 40
      elsif  40 <= avg
        saving_level = 47
        savings = 50
      end
      user = beneficiary.user
      if user.saving_level_id != saving_level
        if user.saving_level_id < saving_level
          variable = true
        else
          variable = false
        end
        user.saving_level_id = saving_level
        user.savings = savings
        user.save
        locale = Gets::locale(user.locale_id)
        ModelMailer.send_statistic_saving_level(
          user.email, user.savings, user.saving_level,
          variable, locale).deliver
      end
    end
    puts "#{Time.now} - All Beneficiary Plan Check!"  
  end

  task :groups => :environment do
    time = Time.now
    day = time.day
    time_custom = time - 2.months
    groups = Group.where(" 
     EXTRACT(DAY FROM created_at) = ? AND 
     created_at <= ? AND 
     plan_id IS NOT NULL AND saving_level_id IS NOT NULL", day, time_custom)

    #groups = Group.where("plan_id IS NOT NULL AND saving_level_id IS NOT NULL")

    for group in groups do
      count = group.group_beneficiaries.count
      if count > 0
        months = (time.year * 12 + time.month) - (group.created_at.year * 12 + group.created_at.month)
        begin
          avg = (Transac.where("pay_wallet_id = ? AND transac_type_id = 119", group.wallet.id).sum(:amount)/months)/count
          if avg.nan? or avg.nil?
            avg = 0
          end
        rescue
          avg = 0
        end
        if 0 <= avg && avg < 20
          saving_level = 43
          savings = 10
        elsif 20 <= avg && avg < 30
          saving_level = 44
          savings = 20
        elsif 30 <= avg && avg < 40
          saving_level = 45
          savings = 30
        elsif 40 <= avg && avg < 50
          saving_level = 46
          savings = 40
        elsif  40 <= avg
          saving_level = 47
          savings = 50
        end
        if group.saving_level_id != saving_level
          if group.saving_level_id < saving_level
            variable = true
          else
            variable = false
          end
          group.saving_level_id = saving_level
          group.savings = savings
          group.save
          locale = Gets::locale(group.locale_id)
          ModelMailer.send_statistic_saving_level(
            group.c_email, group.savings, group.saving_level,
            variable, locale, count).deliver
        end
      end
    end
    puts "#{Time.now} - All Group Plan Check!"  
  end
end
