class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def confirm; end

  def withdraw
    @user = current_user
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = 'ありがとうございました。またのご利用を心よりお待ちしております。'
    # フラッシュメッセージの表示がされていない。
    redirect_to root_path
  end

  def bookmarks
    @user = User.find(params[:user_id])
    @posts = @user.bookmark_posts.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  private

  def user_params
    params.require(:user).permit(:name, :our_answers_id, :email, :profile_image, :introduction)
  end
end
