class Public::UsersController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :find_user, only: [:show, :edit, :update]


  def show
    @posts = if @user == current_user
               @user.posts.includes(:genre).page(params[:page]).per(4).order("#{sort_column} #{sort_direction}")
             else
               @user.posts.where(release: 'true').includes(:genre).page(params[:page]).per(4).order("#{sort_column} #{sort_direction}")
             end
    @user_bookmarks = @user.bookmark_posts.includes(:user, :genre).order("#{sort_column} #{sort_direction}")
  end

  def edit; end

  def update
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

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    Post.column_names.include?(params[:column]) ? params[:column] : "id"
  end

  def find_user
    @user = User.find(params[:id])
  end

end
