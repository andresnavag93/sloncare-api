class GroupBeneficiarySerializer < ActiveModel::Serializer
  attributes :name, :lastname, :document, :email, :wallet_id, :id

  def id
  	object.beneficiary_id
  end
end
