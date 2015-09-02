class AdminController < ApplicationController
  before_action :ensure_admin

  def clone_user
    user = User.find params[:id]
    cookies[:auth_token] = user.auth_token
    redirect_to root_path
  end
end