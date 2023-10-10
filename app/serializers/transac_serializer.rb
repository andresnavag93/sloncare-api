class TransacSerializer < ActiveModel::Serializer
  attributes :id, :amount, :description, :checked, :transac_id, :created_at, :dc

  def dc
    if scope[:wallet] == object.wallet_id
      return false
    else
      return true
    end
  end

end
