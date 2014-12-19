class ShowsController < ApplicationController
  def index
    @no_inherent_row = true
    if @current_user
      watched_shows = @current_user.followed_shows.shuffle
      unwatched_shows = Show.all.shuffle - watched_shows
      @shows = watched_shows + unwatched_shows
    else
      @shows = Show.all.shuffle
    end
  end

  def show
    @show = Show.find(params[:id])
    @seasons = @show.seasons.includes(:episodes).order(:number)
  end

  def watch
    if @current_user
      @show = Show.find(params[:id])
      if params[:watched] == 'true'
        @current_user.followed_shows << @show unless @current_user.followed_shows.include?(@show)
      else
        @current_user.followed_shows.delete(@show)
      end
    end
    render nothing: true
  end
end