class Notification < ApplicationRecord
  
  # フォロー通知にはpost_id、comment_idは関与しないため optional: trueを付けてnilを許容
  # コメント通知にはvisiter_id,visited_idは関与しないのでこちらにもつける
  belongs_to :post, optional: true
  belongs_to :comment, optional: true
  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true
  
  default_scope -> {order(created_at: :desc)}
  
end
