class Public::RelationshipsController < ApplicationController
  # onlyオプションを付けていないのでメソッドの追加時は注意
  before_action :find_user

  def create
    current_user.follow(params[:user_id])
    @user.create_notification_follow(current_user)
  end

  def destroy
    current_user.unfollow(params[:user_id])
  end

  def followings
    @users = @user.followings
  end

  def followers
    @users = @user.followers
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

end
