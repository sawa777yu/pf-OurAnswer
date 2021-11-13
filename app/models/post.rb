class Post < ApplicationRecord
  belongs_to :genre
  belongs_to :user, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_users, through: :bookmarks, source: :user
  has_many :notifications, dependent: :destroy

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  validates :genre_id, presence: true
  validates :reference_url, presence: true
  validates :title, presence: true
  validates :body, presence: true

  # searchコントローラーの表記短縮のため記述
  scope :showable, -> { joins(:user).where(release: true, users: {is_deleted: false }) }


  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      post_id: id,
      visited_id: user_id,
      action: "bookmark"
    )
    notification.save if notification.valid?
  end

  def create_notification_comment(current_user, post_comment_id)
    # pluckは配列で探したいものを探し出せる。それに対してselectはインスタンス変数で抽出する。
    # includeでuser_idを探すためにはselectだと手間が増えるためpluckで記述
    temp_ids = PostComment.where(post_id: id).where.not(user_id: current_user.id).distinct.pluck(:user_id)
    temp_ids.each do |user_id|
      save_notification_comment(current_user, post_comment_id, user_id)
    end
    save_notification_comment(current_user, post_comment_id, user_id) unless temp_ids.include?(user_id)
  end

  def save_notification_comment(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )
    if notification.visiter_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
