class Public::HomesController < ApplicationController
  def top
    @user = current_user
    @genres = Genre.all
    # includesメソッドを使いN+1問題を解消
    @posts = Post.includes(:genre).joins(:user).where(release: true, users: { is_deleted: false }).order(created_at: :desc).limit(4)
    @post_ranks = Post.includes(:genre, :user).joins(:user).where(release: true, users: { is_deleted: false }).limit(4).sort do |a, b|
      b.bookmarked_users.size <=> a.bookmarked_users.size
    end
  end

  def about; end
end
