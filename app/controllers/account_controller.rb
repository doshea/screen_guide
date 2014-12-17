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

    current_episode_ids = @current_user.episodes.map(&:id)
    @unwatched_followed = Episode.joins(:show).where(shows: {id: @current_user.followed_shows.map(&:id)}).where.not(id: current_episode_ids).by_air_date

    @queued, @today, @upcoming = [], [], []

    while (@unwatched_followed.any? && (@unwatched_followed.first.air_date < @west_coast_date))
      @queued << @unwatched_followed.to_a.shift
    end
    while (@unwatched_followed.any? && (@unwatched_followed.first.air_date == @west_coast_date))
      @today << @unwatched_followed.to_a.shift
    end
    while (@unwatched_followed.any? && (@unwatched_followed.first.air_date > @west_coast_date))
      @upcoming << @unwatched_followed.to_a.shift
    end
  end

  private ###
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :image)
  end
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

end