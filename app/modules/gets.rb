module Gets
  class << self

    def locale(locale=28)
      if !locale.nil? and locale.to_i == 29 
        return :en 
      else
        return :es
      end
    end

    def errors(obj, list=[])
      for k,v in obj
        list << v
      end
      return list
    end

    def one(model, key, value, obj_params, n_obj=true, code=nil)
      obj = model.find_by key => value
      if !obj 
        if n_obj
          obj = model.new(obj_params)
          return self.errors(obj.errors) if !obj.valid?
          obj.save
        else
          return [code]
        end
      end
      return obj
    end

    def md5_encrypt(obj, *args)
      for arg in args
        obj.public_send("#{arg}=", Digest::MD5.hexdigest(obj.public_send(arg).to_s))
      end
    end

    def user_many(model, access_id, visibility=false)
      if visibility
        objs = model.where("access_id = ? AND visibility", access_id)
      else
        objs = model.where("access_id = ?", access_id).includes(:user)
      end
      list = []
      n = 1
      for obj in objs
        user = obj.user
        user._id = n
        user._name = user.name
        n += 1
        list << user
      end
      return list
    end

    def protocols(object)
      objs = object.wallet.protocols
      for obj in objs
        if obj.amount >= object.wallet.balance
          obj.is_active = false
        else
          obj.is_active = true
        end
      end
      return objs
    end

    def creditcard(obj)
      if obj.customer_id
        card = CustomStripe::list_all_creditcards(obj.customer_id)
        if card 
          return card  
        else
          return {}
        end
      else
        return {}
      end
    end

    def user_access(email, access_id)
      obj = UserAccess.joins(:user).where("email = ? AND access_id = ?", email, access_id)
      if obj.exists?
        return obj[0]
      else
        return nil
      end
    end

    def younger?(date)
      begin
        age = ((Time.zone.now - date.to_time) / 1.year.seconds).floor
        if age < 18
          return true
        else
          return false
        end
      rescue Exception => e
        return false
      end
    end
  end
end