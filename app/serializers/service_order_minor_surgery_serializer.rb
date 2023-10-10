class ServiceOrderMinorSurgerySerializer < ActiveModel::Serializer
  #Order Info
  attributes :service_type_id,
    :id, :created_at,
    :o_appointment_date, :priority,
    :entry_date, :total, :status, :status_id,
    :specialty,
    :room_number, :livelihood,
  #Beneficiary
    :b_observations,
    :reason_for_admission, :symptom,
    :beneficiary,
  #Provides
    :p_observations,
    :provider,
  #Status Caused
    :recipe, :recipe_comments, :indications, :indications_comments,
    :medical_report, :diagnosis,  :evolutionary_report, :egress_report, :egress_date,
    :high,
  #Records
    :items,
    :wallet

  def priority
    object.priority.name
  end

  def specialty
    object.specialty.name
  end

  def status
    if object.status_id == 92
      return time = (30 - ((Time.now -  object.created_at).to_i/ 86400)).to_s 
    else
      return nil
    end
  end

  def high
    begin
      object.high.name
    rescue
      return nil
    end
  end

  def beneficiary
    if !scope[:access_id].nil? and [73, 70, 71, 74].include? scope[:access_id]
      obj = {}
      user = object.beneficiary
      obj[:id] = user.id
      obj[:wallet_id] = user.wallet_id
      obj[:name] = user.user.name
      obj[:lastname] = user.user.lastname
      obj[:birthday] = user.user.birthday
      obj[:document] = user.user.document
      obj[:cellphone] = user.user.cellphone
      obj[:email] = user.user.email
      obj[:younger] = Gets::younger?(user.user.birthday)
      return obj
    else
      return nil
    end
  end

  def provider
    if !scope[:access_id].nil? and [73, 69].include? scope[:access_id]
      obj = {}
      user = object.provider
      if !object.provider.visibility and object.status_id != 93
        obj[:id] = user.id
        obj[:wallet_id] = user.wallet_id
        obj[:name] = "--"
        obj[:lastname] = "--"
        obj[:birthday] = "--"
        obj[:document] = "--"
        obj[:cellphone] = "--"
        obj[:localphone] = "--"
        obj[:email] = "--"
      else
        obj[:id] = user.id
        obj[:wallet_id] = user.wallet_id
        obj[:name] = user.user.name
        obj[:lastname] = user.user.lastname
        obj[:birthday] = user.user.birthday
        obj[:document] = user.user.document
        obj[:cellphone] = user.user.cellphone
        obj[:localphone] = user.user.localphone
        obj[:email] = user.user.email
      end
      return obj
    else
      return nil
    end
  end

  def items
    object.order_records.order("record_id")
  end

  def wallet
    obj = {}
    if object.group.nil?
      wallet = object.beneficiary.wallet
    else
      wallet = object.group.wallet
    end  
    obj[:wallet_id] = wallet.id
    obj[:available] = wallet.available
    return obj
  end

end
