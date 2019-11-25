class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts, dependent: :destroy
  mount_uploader :avatar, AvatarUploader

 
  has_many :comments, dependent: :destroy
  has_many :likings, class_name: 'Like',
          foreign_key: :liker_id,
          dependent: :destroy
  has_many :posts_liked, through: :likings,
           source: :likeable,
           source_type: "Post"

  has_many :comments_liked, through: :likings,
           source: :likeable,
           source_type: "Comment"
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships
  has_many :friend_requests_sent, class_name: 'FriendRequest' ,
           dependent: :destroy
  has_many :friends_pending, through: :friend_requests_sent,
           source: :friend
  has_many :friend_requests_received, class_name: 'FriendRequest',
           foreign_key: :friend_id,
           dependent: :destroy
  has_many :friends_to_confirm, through: :friend_requests_received,
           source: :user


  validates :first_name, presence: true,
            length: { maximum: 50 }
  validates :last_name, presence: true,
            length: { maximum: 50 }
  validates :gender, presence: true
  validates :birthday, presence: true
  enum gender: [:male, :female, :other]
  validates :username, presence: true,
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }


  def self.search(query)
    return User.none if query.blank?
      # where("concat_ws(' ', first_name, last_name, first_name, username) LIKE ?", "%#{query.squish}%")

    User.where('first_name LIKE :search OR last_name LIKE :search OR username LIKE :search', search: "%#{query}%")

  end

  def self.find_by_username(username)
    where("LOWER(username) = ?", username.downcase).first
  end


  def to_param
    username
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def friends_with?(user)
    friends.include? user
  end

end
