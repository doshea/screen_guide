class AccountController < ApplicationController
  before_filter :ensure_logged_in

  def show
  end

  def update
    @current_user.update_attributes(profile_params)
    render :show
  end

  def change_password
    if @current_user.authenticate(params[:old_password])
      @current_user.update_attributes(password_params)
    end
    redirect_to account_path
  end

  def shows
    @shows = @current_user.shows
  end

  def queue
    @queued = Episode.joins(:show).where(shows: {id: @current_user.shows.map{|s| s.id}}).where.not(id: @current_user.episodes.map{|e| e.id}).where("air_date <= ?", Date.today).by_air_date
    @upcoming = Episode.joins(:show).where(shows: {id: @current_user.shows.map{|s| s.id}}).where.not(id: @current_user.episodes.map{|e| e.id}).where("air_date > ?", Date.today).by_air_date
  end

  private ###
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :image)
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end