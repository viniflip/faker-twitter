class PostSerializer < ActiveModel::Serializer
  attributes :id, :user, :message, :created_at

  def user
    { id: object.user.id, name: object.user.name }
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y %H:%M')
  end
end
