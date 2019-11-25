class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  validate :self_friend
  def self.fetch(user1, user2)
    where(user: user1, friend: user2).first
  end

  def self.add_friend(user_id, friend_id)
    user_friendship = Friendship.create(user_id: user_id, friend_id: friend_id)
    friend_friendship = Friendship.create(user_id: friend_id, friend_id: user_id)
    fr = FriendRequest.find_by(user_id: friend_id, friend_id: user_id)
    if fr
      fr.destroy
    end
  end


  def self.unfriend(user_id, friend_id)
    friendship1 = Friendship.find_by(user_id: user_id, friend_id: friend_id)
    friendship2 = Friendship.find_by(user_id: friend_id, friend_id: user_id)
    friendship1.destroy
    friendship2.destroy
  end

  def self_friend
    errors.add(:user_id, "not permitted") if user_id == friend_id
  end

end
