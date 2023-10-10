class BeneficiaryOneSerializer < ActiveModel::Serializer
  attributes :name, :lastname, :document, :email, :localphone, :cellphone,
   :nationality, :profession, :picture, :weight, :c1_name, :c1_lastname,
   :c1_localphone, :c1_cellphone, :c1_email, :c2_name, :c2_lastname, :c2_localphone,
   :c2_cellphone, :c2_email, :customer_id, :savings, :line_1, :line_2, :country_id, 
   :country, :state_id, :state, :city_id, :city,
   :plan_id, :plan, :saving_level_id, :saving_level, :weight_unit_id,
   :weight_unit, :size, :size_unit, :zipcode, :locale_id, :younger, :birthday, 
   :cc_localphone,
   :cc_c1_localphone,
   :cc_c2_localphone,
   :cc_cellphone,
   :cc_c1_cellphone,
   :cc_c2_cellphone,
   :cc_d_phone

  def younger
    return Gets::younger?(object.birthday)
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

  def weight_unit
    begin
      weight_unit = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        weight_unit[:name] = object.weight_unit.name_en
      else
        weight_unit[:name] = object.weight_unit.name
      end
      return weight_unit
    rescue
      return nil
    end
  end

  def size_unit
    begin
      size_unit = {}
      if !scope[:locale].nil? and scope[:locale].to_i == 29
        size_unit[:name] = object.size_unit.name_en
      else
        size_unit[:name] = object.size_unit.name
      end
      return size_unit
    rescue
      return nil
    end
  end

end