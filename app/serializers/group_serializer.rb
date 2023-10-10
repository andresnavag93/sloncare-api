class GroupSerializer < ActiveModel::Serializer
  attributes :id, :savings, :is_active, :b_count, :a_count, :customer_id, :c_name, :c_lastname, 
    :c_document, :c_rif, :c_rifnumber, :c_email, :c_localphone, :c_cellphone, 
    :c1_name, :c1_lastname, :c1_workstation, :c1_localphone, :c1_cellphone, 
    :c1_email, :c2_name, :c2_lastname, :c2_workstation, :c2_localphone, :c2_cellphone, 
    :c2_email, :line_1, :line_2, :zipcode,:wallet_id,
    :plan_id, :plan,:saving_level_id, :saving_level,:country_id,
    :country, :state_id, :state, :city_id, :city,
    :zipcode, :locale_id,
    :cc_localphone,
    :cc_c1_localphone,
    :cc_c2_localphone,
    :cc_cellphone,
    :cc_c1_cellphone,
    :cc_c2_cellphone
  has_one :wallet
  has_many :protocols, serializer: ProtocolSerializer

  def wallet
    object.wallet
  end

  def country
    begin
      country = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        country[:name] = object.country.name_en
      else
        country[:name] = object.country.name
      end
      return country
    rescue
      return nil
    end
  end

  def state
    begin
      state = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        state[:name] = object.state.name_en
      else
        state[:name] = object.state.name
      end
      return state
    rescue
      return nil
    end
  end

  def city
    begin
      city = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        city[:name] = object.city.name_en
      else
        city[:name] = object.city.name
      end
      return city
    rescue
      return nil
    end
  end

  def protocols
    objs = TblAttribute.where("tbl_attribute_id = 6")
    active_protocols = object.wallet.protocols
    no_active_protocols = objs - active_protocols    
    active_protocols.each do |p|
      p.is_active = true
    end
    no_active_protocols.each do |p|
      p.is_active = false
    end
    return active_protocols + no_active_protocols
  end

  # def protocols
  # 	begin
  # 		return Gets::protocols(object)
  # 	rescue
  # 		return []
  # 	end
  # end

  def plan
    begin
      plan = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        plan[:name] = object.plan.name_en
      else
        plan[:name] = object.plan.name
      end
      return plan
    rescue
      return nil
    end
  end

  def saving_level
    begin
      saving_level = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        saving_level[:name] = object.saving_level.name_en
      else
        saving_level[:name] = object.saving_level.name
      end
      return saving_level
    rescue
      return nil
    end
  end

end
