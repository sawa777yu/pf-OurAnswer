class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @posts = Post.includes(:genre).where(release: 'true').order(created_at: :desc).limit(4)
    @post_ranks = Post.includes(:genre, :user).where(release: 'true').limit(4).sort do |a, b|
      b.bookmarked_users.size <=> a.bookmarked_users.size
    end
    # includesメソッドを使いN+1問題を解消
  end

  def about; end
end
