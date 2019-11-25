class Post < ApplicationRecord
  mount_uploader :photo, PhotoUploader
  belongs_to :user
  belongs_to :poster, class_name: 'User'
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes
  validates :body, presence: true

  default_scope { order(created_at: :desc) }
  validates :body, presence: true,
            length: { maximum: 1000 }

  def owner
    user
  end

  def author
    poster
  end


end
