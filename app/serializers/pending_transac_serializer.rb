class PendingTransacSerializer < ActiveModel::Serializer
  attributes :wallet_id, 
    :id, :fee, :amount, :total, :checked, 
    :transac_id, :transac_id, :created_at,
    :zelle, :bank_name, :account, :comments, :swift, :aba, :paypal, :stripe,
    :country_name,
    :state_name,
    :city_name,
    :zipcode,
    :holder_name,
    :holder_email,
    :address

  def fee
    object.amount
  end

  def amount
    object.transac.amount
  end

  def total
    object.transac.amount - object.amount
  end

  def  zelle  
    object.transac.zelle  
  end

  def  bank_name
    object.transac.bank_name
  end

  def  account
    object.transac.account
  end

  def  comments
    object.transac.comments
  end

  def  swift
    object.transac.swift
  end

  def  aba
    object.transac.aba
  end

  def  paypal
    object.transac.paypal
  end

  def  stripe
    object.transac.stripe
  end

  def  country_name
    object.transac.country_name
  end

  def  state_name
    object.transac.state_name
  end

  def  city_name
    object.transac.city_name
  end

  def  zipcode
    object.transac.zipcode
  end

  def  holder_name
    object.transac.holder_name
  end

  def  holder_email
    object.transac.holder_email
  end

  def  address
    object.transac.address
  end

end
