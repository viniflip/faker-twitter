class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :created_at
  has_many :posts, serializer: PostSerializer
  has_many :follower_relationships, serializer: FollowSerializer
  has_many :following_relationships, serializer: FollowSerializer

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def posts
     object.posts.order(created_at: :desc)
  end
end
