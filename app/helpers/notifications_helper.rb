module NotificationsHelper

  def notification_form(notification)
    @visiter = notification.visiter
    @visiter_comment = notification.comment_id
    case notification.action
      when "follow" then
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"があなたをフォローしました"
      when "bookmark" then
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が ”"+
        tag.a(notification.post.title.truncate(20), href:post_path(notification.post_id), style:"font-weight: bold;")+"” をブックマークしました"
      when "comment" then
        @post_comment = PostComment.find_by(id: @visiter_comment)&.comment
        tag.a(@visiter.name, href:user_path(@visiter), style:"font-weight: bold;")+"が ”"+
        tag.a(notification.post.title.truncate(20), href:post_path(notification.post_id), style:"font-weight: bold;")+"” にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

end
