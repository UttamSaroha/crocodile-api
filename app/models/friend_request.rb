class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validate :self_friend
  validate :if_already_friends
  def self.fetch(user1, user2)
    where(user: user1, friend: user2).first
  end

  def self_friend
    errors.add(:user_id, "not permitted") if user_id == friend_id
  end

  def if_already_friends
  if Friendship.exists?(user: user_id, friend: friend_id)
    errors.add(:friend_id, "already friends")
  end
    end
end
