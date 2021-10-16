class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :follower_of_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :follower_of_relationships, source: :followed
  has_many :followed_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :followed_of_relationships, source: :follower

  attachment :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def follow(user_id)
    follower_of_relationships.create(followed_id: user_id)
  end

  def unfollow(user_id)
    follower_of_relationships.find_by(followed_id: user_id).destroy
  end

  def following?(user)
    followings.include?(user)
  end

  validates :name, presence: true
  validates :our_answers_id, presence: true
end
