class Public::PostCommentsController < ApplicationController
  before_action :set_post
  
  def create
    comment = current_user.post_comments.new(post_comment_params)
    comment.post_id = @post.id
    comment.save
    @post.create_notification_comment(current_user, comment.id)
  end

  def destroy
    PostComment.find_by(id: params[:id]).destroy
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment, :rate)
  end
  
  def set_post
    @post = Post.find(params[:post_id])
    @post_comments = @post.post_comments
    @post_comment = PostComment.includes(:user).new
  end
end
