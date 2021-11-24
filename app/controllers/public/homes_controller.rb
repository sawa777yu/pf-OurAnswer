class Public::HomesController < ApplicationController
  def top
    @user = current_user
    @genres = Genre.all
    # showable -> { joins(:user).where(release: true, users: {is_deleted: false }) }
    @new_posts = Post.includes(:genre).showable.limit(4).order(created_at: :desc)
    @post_ranks = Post.showable.includes(:user, :genre).left_joins(:bookmarks).group(:id).order('count(post_id) desc').limit(4)
  end

  def about; end
end
