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

  def queue
    hr_adjustment = Rails.env.production? ? 7 : 0
    @west_coast_time = Time.now - hr_adjustment.hours
    @west_coast_date = Date.parse(@west_coast_time.to_s)

    # New SQL
    unfinished_shows = @current_user.followed_shows.where.not(id: @current_user.watched_shows)
    unfinished_seasons = Season.joins(:show).where(shows: {id: unfinished_shows.map(&:id)}).where.not(id: @current_user.watched_seasons)
    @unfinished_episodes = Episode.joins(:season).where(seasons: {id: unfinished_seasons.map(&:id)}).where.not(id: @current_user.watched_episodes).by_air_date

    @queued, @today, @upcoming = [], [], []

    while (@unfinished_episodes.any? && (@unfinished_episodes.first.air_date < @west_coast_date))
      @queued << @unfinished_episodes.to_a.shift
    end
    while (@unfinished_episodes.any? && (@unfinished_episodes.first.air_date == @west_coast_date))
      @today << @unfinished_episodes.to_a.shift
    end
    while (@unfinished_episodes.any? && (@unfinished_episodes.first.air_date > @west_coast_date))
      @upcoming << @unfinished_episodes.to_a.shift
    end
  end

  def flip_queue
    @current_user.toggle!(:queue_oldest_first)
  end

  private ###
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :image)
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end