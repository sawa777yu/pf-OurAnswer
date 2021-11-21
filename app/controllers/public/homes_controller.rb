class Public::HomesController < ApplicationController
  def top
    @user = current_user
    @genres = Genre.all
    # showable -> { joins(:user).where(release: true, users: {is_deleted: false }) }
    @new_posts = Post.includes(:genre).showable.limit(4).order(created_at: :desc)
    @post_ranks = Post.includes(:genre, :user).showable.limit(4).sort do |a, b|
      b.bookmarked_users.size <=> a.bookmarked_users.size
    end
  end

  def about; end
end
