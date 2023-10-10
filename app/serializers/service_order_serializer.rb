class ServiceOrderSerializer < ActiveModel::Serializer
  attributes :service_type_id,
    :id, :o_appointment_date, :total, :created_at,
    :specialty, :provider_name, :provider_lastname, 
    :status, :status_id, :beneficiary_name, :beneficiary_lastname,

  def specialty
      object.specialty.name
  end

  def provider_name
    if !scope[:access_id].nil? and [73, 69].include? scope[:access_id]
      if !object.provider.visibility and object.status_id != 93
        return "--"
      else
        return object.provider.user.name
      end
    else
      nil
    end
  end

  def provider_lastname
    if !scope[:access_id].nil? and [73, 69].include? scope[:access_id]
      if !object.provider.visibility and object.status_id != 93
        return "--"
      else
        return object.provider.user.lastname
      end
    else
      nil
    end
  end

  def beneficiary_name
    if !scope[:access_id].nil? and [73, 70, 71, 74].include? scope[:access_id]
      object.beneficiary.user.name
    else
      nil
    end
  end

  def beneficiary_lastname
    if !scope[:access_id].nil? and [73, 70, 71, 74].include? scope[:access_id]
      object.beneficiary.user.lastname
    else
      nil
    end
  end

  def status
    if object.status_id == 92
      return time = (30 - ((Time.now -  object.created_at).to_i/ 86400)).to_s 
    else
      return nil
    end
  end

 end
