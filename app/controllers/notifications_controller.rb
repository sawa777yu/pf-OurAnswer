class NotificationsController < ApplicationController
  def index
    # include(:vistiter)は、コメントの通知がある場合の通知一覧画面でのbulletのアラート解消のため記述
    @notifications = current_user.passive_notifications.includes(:visiter, :post)
    @notifications.where(checked: false).update_all(checked: true)
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to notifications_path
  end
end
