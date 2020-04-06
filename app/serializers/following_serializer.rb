class FollowingSerializer < ActiveModel::Serializer
  attributes :id, :name, :email
  has_many :posts, serializer: PostSerializer
end
