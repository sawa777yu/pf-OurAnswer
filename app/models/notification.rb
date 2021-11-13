class Notification < ApplicationRecord

  # フォロー通知にはpost_idは関与しないため optional: trueを付けてnilを許容
  belongs_to :post, optional: true
  belongs_to :visiter, class_name: 'User', foreign_key: 'visiter_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

  default_scope -> {order(created_at: :desc)}

end
