namespace :service_orders do

  task :cancelling => :environment do
    time = Time.now - 30.days
    service_orders = ServiceOrder.where("created_at <= ? AND status_id in (?)", time, [90,91,92])

    #service_orders = ServiceOrder.all

    for service_order in service_orders
      if ([90, 91].include? service_order.status_id and [84, 85, 86].include? service_order.service_type_id) or service_order.status_id == 92
        if !service_order.group_id.nil?
          wallet = service_order.group.wallet
        else
          wallet = service_order.beneficiary.wallet
        end
        #Change status to Cancel
        service_order.status_id = 94
        service_order.save
        #Status deferred wallet beneficiary and put to his balanca

        if !service_order.total.nil?
          if service_order.service_type_id == 88  
            if service_order.status_id == 92
              wallet.available += service_order.total
              wallet.deferred -= service_order.total
              #wallet.balance = wallet.available + wallet.deferred
              wallet.save
            end
          else
            wallet.available += service_order.total
            wallet.deferred -= service_order.total
            #wallet.balance = wallet.available + wallet.deferred
            wallet.save
          end
        end
      end
    end
    puts "#{Time.now} - All Service Order Recurring Payment Check!"
  end
end