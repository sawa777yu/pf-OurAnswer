class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_posts, through: :bookmarks, source: :post
  has_many :follower_of_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy
  has_many :followings, through: :follower_of_relationships, source: :followed
  has_many :followed_of_relationships, class_name: 'Relationship', foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :followed_of_relationships, source: :follower
  # active_notifications:自分が作った通知　visiter_id:通知を送ったユーザーのid
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visiter_id', dependent: :destroy
  # passive_notifications:自分宛の通知　visited_id:通知を送られたユーザーのid
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

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

  # searchコントローラーの表記短縮のため記述
  scope :valid_user, -> { where(is_deleted: false) }

  def create_notification_follow(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and action = ? ", current_user.id, id, "follow"])
    # フォローの通知は最初にフォローしたときしか行かないようにする。（フォローしたり外したりを繰り返すと複数の通知ができてしまうため）
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: "follow"
      )
      notification.save if notification.valid?
    end
  end

end
