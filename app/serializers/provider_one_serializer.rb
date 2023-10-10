class ProviderOneSerializer < ActiveModel::Serializer
  attributes :id,
    :name, :lastname, :document, :businessname, :email, :rif,  :rifnumber, 
    :localphone, :cellphone, :d_name, :d_lastname, :d_document, :d_phone,
    :d_email, :d_picture, :c1_name, :c1_lastname, :c1_workstation, :c1_localphone,
    :c1_cellphone, :c1_email, :c2_name, :c2_workstation, :c2_localphone,
    :c2_cellphone, :c2_email, :picture, :line_1,  :line_2, :country_id,
    :country, :state_id, :state, :city_id, :city,
    :zipcode, :locale_id,
    :cc_localphone,
    :cc_c1_localphone,
    :cc_c2_localphone,
    :cc_cellphone,
    :cc_c1_cellphone,
    :cc_c2_cellphone,
    :cc_d_phone

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
end