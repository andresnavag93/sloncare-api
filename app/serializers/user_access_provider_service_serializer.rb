class UserAccessProviderServiceSerializer < ActiveModel::Serializer
  attributes :id, :wallet_id, :name, :_id, :_name
  has_one :user, serializer: ProviderSerializer 

  def name 
    if object.visibility
      n = ''
      n += object.user.name if object.user.name
      n += ' ' + object.user.lastname if object.user.lastname
      return n
    else
      return nil
    end
  end

  def _name 
    if object.visibility
      n = 'Wallet id: ' + object.wallet_id.to_s + ' - '
      n += 'Nombre: ' + object.user.name if object.user.name
      n += ' ' + object.user.lastname if object.user.lastname
      return n
    else
      n = 'Wallet id: ' + object.wallet_id.to_s + ' - **'
      return n
    end
  end

end