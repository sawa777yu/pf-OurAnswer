class Public::UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @posts = if @user == current_user
               @user.posts.includes(:genre).page(params[:page]).per(10)
             else
               @user.posts.where(release: 'true').includes(:genre).page(params[:page]).per(10)
             end
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
    redirect_to root_path
  end

  def bookmarks
    @user = User.find(params[:user_id])
    @posts = @user.bookmark_posts.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def new_guest
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      # find_or_create_by　ユーザーが見つからなければemailを生成してくれるメソッド
      user.password = SecureRandom.alphanumeric(7)
      # ランダムパスワードを自動生成
      user.name = 'ゲスト'
      user.our_answers_id = 'guest'
    end
    sign_in user
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :our_answers_id, :email, :profile_image, :introduction)
  end
end
