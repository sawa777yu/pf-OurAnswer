class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end


  validates :genre_id, presence: true
  validates :reference_url, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :release, presence: true
end
