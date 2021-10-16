class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @posts = Post.all.order(created_at: :desc).limit(4)
    @post_ranks = Post.includes(:bookmarked_users).sort { |a, b| b.bookmarked_users.size <=> a.bookmarked_users.size }
  end
end
