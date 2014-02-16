class ShowsController < ApplicationController
  def index
    @active = Show.active
    @inactive = Show.inactive
  end

  def show
    @show = Show.find(params[:id])
    @seasons = @show.seasons.includes(:episodes).order(:number)
  end

  def watch
    if @current_user
      @show = Show.find(params[:id])
      if params[:watched].present?
        @current_user.shows << @show unless @current_user.shows.include?(@show)
      else
        @current_user.shows.delete(@show)
      end
    end
    render nothing: true
  end
end