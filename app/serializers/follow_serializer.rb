class FollowSerializer < ActiveModel::Serializer
  belongs_to :following, serializer: FollowingSerializer
  belongs_to :follower, serializer: FollowerSerializer
end
