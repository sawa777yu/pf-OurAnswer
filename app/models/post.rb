class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user, dependent: :destroy
  has_many :post_comments, dependent: :destroy

  validates :genre_id, presence: true
  validates :reference_url, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :release, presence: true
end
