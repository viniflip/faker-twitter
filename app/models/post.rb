class Post < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'

  validates_presence_of :message
  validates_length_of :message, maximum: 280

  scope :subscribed, ->(followers) { where user_id: followers }

end
