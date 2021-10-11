class User < ApplicationRecord
  has_many :posts
  attachment :profile_image

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :our_answers_id, presence: true
end
