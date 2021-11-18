class Public::PostsController < ApplicationController
  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    #NaturalLnguageAPIの機能のため追記
    @post.score = Language.get_data(post_params[:body])
    if @post.save
      redirect_to post_path(@post)
    else
      @genres = Genre.all
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @post_comment = PostComment.includes(:user).new
    @post_comments = @post.post_comments
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
    if @post.user == current_user
      render :edit
    else
      redirect_to post_path(@post)
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.score = Language.get_data(post_params[:body])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      @genres = Genre.all
      render :edit
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :genre_id, :user_id, :reference_url, :release, :rate)
  end
end
