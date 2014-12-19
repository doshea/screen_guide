class ShowsController < ApplicationController
  def index
    @shows = Show.all
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