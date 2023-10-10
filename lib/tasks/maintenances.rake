namespace :maintenances do

  task :monthly_wallet => :environment do
    time = Time.now
    if time.day == time.end_of_month.day
      slonwallet = Wallet.find(1)
      fee_percentage = TblAttribute.find(125).amount.to_d

      users = UserAccess.where("id != ? and wallet_id is not ? and access_id != 72", 1, nil)
      users.each do |user|
        wallet = user.wallet
        fee = ((wallet.available.to_d * fee_percentage)/100).round(2)
        if fee == 0
          next
        else
          wallet.balance -= fee
          wallet.available -= fee
          wallet.save
          slonwallet.balance += fee
          slonwallet.available += fee
          slonwallet.save

          locale = Gets::locale(user.user.locale_id)
          I18n.locale = locale
          msg = I18n.t 'model_mailer.transaction.fee_maintenance'
          Transac.new({amount: fee, description: msg, wallet: wallet, pay_wallet: slonwallet, currency_id: 117, transac_type_id: 125}).save
        end
      end

      Group.all.each do |group|
        wallet = group.wallet
        fee = ((wallet.available.to_d * fee_percentage)/100).round(2)
        if fee == 0
          next
        else
          wallet.balance -= fee
          wallet.available -= fee
          wallet.save
          slonwallet.balance += fee
          slonwallet.available += fee
          slonwallet.save

          locale = Gets::locale(group.locale_id)
          I18n.locale = locale
          msg = I18n.t 'model_mailer.transaction.fee_maintenance'
          Transac.new({amount: fee, description: msg, wallet: wallet, pay_wallet: slonwallet, currency_id: 117, transac_type_id: 125}).save
        end
      end
      ModelMailer.send_contact_request(
        "anavarro@wayuinc.com", "All Maintenances Monhtly Check!", 
        Time.new, "es", "anavarro@wayuinc.com").deliver 
      puts "#{time} - All Maintenances Monhtly Check!"  
    #else
      # ModelMailer.send_contact_request(
      #   "anavarro@wayuinc.com", "No Maintenaces check!", 
      #   Time.new, "es", "anavarro@wayuinc.com").deliver 
    end    
  end

end