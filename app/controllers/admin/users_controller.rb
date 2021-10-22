class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  skip_before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.save(user_params)
    redirect_to admin_root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :our_answers_id, :email, :is_deleted)
  end
end
