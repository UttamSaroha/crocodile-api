class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes

  default_scope { order(created_at: :desc) }

  validates :body, presence: true,
            length: { maximum: 250}

  def owner
    post.user
  end

  def author
    user
  end

end
