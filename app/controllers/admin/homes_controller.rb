class Admin::HomesController < ApplicationController
  def top
    @users = User.page(params[:page]).order(created_at: :desc).per(10)
  end
end
