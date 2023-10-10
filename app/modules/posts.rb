module Posts
  class << self
    def change_code(code, wallet, locale, a_wallet=1)
      I18n.locale = locale.to_sym
      msg_in = I18n.t 'model_mailer.transaction.recharge_sloncard'
      msg_out = I18n.t 'model_mailer.transaction.fee_recharge'
      transac_in = Transac.new({amount: code.price, description: msg_in, outcome: false, income: true, pay_wallet: wallet, currency_id: 117, transac_type_id: 118})
      transac_in.save
      slonwallet = Wallet.find(a_wallet)
      Transac.new({amount: code.fee, description: msg_out, outcome: true, income: false, wallet: wallet, pay_wallet: slonwallet, currency_id: 117, transac_type_id: 123, transac: transac_in}).save
      code.transac_id = transac_in.id
      code.save
      wallet.balance += (code.price - code.fee)
      wallet.available += (code.price - code.fee)
      slonwallet.balance += code.fee
      slonwallet.available += code.fee
      wallet.save
      slonwallet.save
      return wallet
    end

    def membership(token, obj, email, code)
      if token != nil
        customer = CustomStripe::membership(token, email, code)
        if customer != code
          obj.customer_id = customer.id
          obj.save
          code = true
        end
      end
      return code
    end

    def charge_recurring(customer_id, currency, amount, wallet, email, locale, count=nil, a_wallet=1)
      if !count.nil?
        aux = count*amount
      else
        aux = amount
      end
      charge = Stripe::Charge.create({amount: (aux*100).to_i, currency: currency, customer: customer_id })
      if !charge.status == "succeeded"
        ModelMailer.send_recurring_payment_wallet(email, amount, wallet, locale, false).deliver
      else 
        balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
        fee = balance.fee/100.0
        while true
          random_code = SecureRandom.hex(6).downcase
          code = Sloncode.new({p_reference: charge.id, fee: fee, code: random_code, price: amount, payment_id: 34, currency_id: 117})
          if code.valid?
            code.save
            break
          end
        end
        I18n.locale = locale.to_sym
        msg = I18n.t 'model_mailer.transaction.recharge_monthly'
        transac_in = Transac.new({amount: aux, outcome:false, income:true, description: msg, pay_wallet: wallet, currency_id: 117, transac_type_id: 119})
        transac_in.save
        code.transac_id = transac_in.id
        code.save
        msg = I18n.t 'model_mailer.transaction.fee_recharge'
        slonwallet = Wallet.find(a_wallet)
        Transac.new({amount: fee, description: msg, outcome: true, income: false, wallet: wallet, pay_wallet: slonwallet, currency_id: 117, transac_type_id: 123, transac: transac_in}).save
        wallet.balance += (aux - fee)
        wallet.available += (aux - fee)
        slonwallet.balance += fee
        slonwallet.available += fee
        wallet.save
        slonwallet.save
        ModelMailer.send_recurring_payment_wallet(email, amount, wallet, locale, true, count).deliver
      end
    end
  end
end