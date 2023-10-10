module Checks
  class << self
    
    def valid?(model, obj_params, *args)
      obj = model.new(obj_params)
      for arg in args
        obj.public_send("#{arg[0]}=", arg[1])
      end
      if !obj.valid?
        return Gets::errors(obj.errors)
      else
        return obj
      end
    end

    def has_key_and_not_null(obj_key, code, params)
      return code if !params.has_key?(obj_key)
      return code if params[obj_key] == nil
      return code if !params[obj_key].kind_of?(Array)
      return {}
    end

    def multy_exists?(objects_key, code, model, code2, params)
      aux = self.has_key_and_not_null(objects_key, code, params)
      begin
        if aux == {}
          aux2 = []
          for obj in params[objects_key]
            if obj.has_key?(:id)
              aux2 << model.find(obj[:id].to_i)
            else 
              return code2
            end
          end
          return aux2
        else
          return aux
        end
      rescue
        return code2
      end
    end 
    
    def valid_code?(model, key, value, function, *code)
      obj = model.find_by key => value
      if !obj 
        return code[0]
      elsif obj.public_send(function) != nil
        return code[1]
      else
        return obj
      end
    end


    def wallet_active_protocols?(protocolos_id, service_type)
      case service_type.to_i
      when 84
        return true if ([38, 39, 40, 41, 42] & protocolos_id).any?
      when 85
        return true if ([39, 40, 41, 42] & protocolos_id).any?
      when 86
        return true if ([40, 41, 42] & protocolos_id).any?
      when 87
        return true if ([40, 42] & protocolos_id).any?
      when 88
        return true if ([38, 39, 40, 41, 42] & protocolos_id).any?
      when 89
        return true if ([40, 42] & protocolos_id).any?
      end
      return false
    end
  end
end