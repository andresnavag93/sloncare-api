module CustomStripe
  class << self
    
    def charge(token, amount, currency, code)
      begin
        charge = Stripe::Charge.create({amount: amount.to_i, currency: currency, source: token})
        if charge.status == "succeeded" 
          balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)
          fee = balance.fee/100.0
          return [charge.id, fee] 
        else 
          return code
        end

      rescue Exception => e
        return code
      end
    end

    def membership(token, email, code)
      begin
        return Stripe::Customer.create({source: token, email: email})
      rescue Exception => e
        puts e
        return code
      end
    end

    def list_all_creditcards(customer_id)
      begin
        cards = Stripe::Customer.retrieve(customer_id).sources.all(
          :limit => 1, 
          :object => "card")
        return cards.data[0]
      rescue Exception => e
        puts e
        return false
      end
    end

    def update_creditcard(customer_id, token, code)
      begin
        customer = Stripe::Customer.retrieve(customer_id)
        for obj in customer.sources.all
          obj.delete
        end
        card = customer.sources.create(source: token)
        return card
      rescue Exception => e
        puts e
        return code
      end
    end

    def destroy_creditcard(customer_id, code)
      begin
        customer = Stripe::Customer.retrieve(customer_id)
        customer.delete
        return {}
      rescue Exception => e
        puts e
        return code
      end
    end

    def charge_recurring_creditcard(amount, currency, customer_id, code)
     begin
       charge = Stripe::Charge.create({
           amount: amount.to_i,
           currency: currency,
           customer: customer_id,
       })
       return charge
     rescue Exception => e
       puts e
       return code
     end
    end

  end
end