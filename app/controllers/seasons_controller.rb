class SeasonsController < ApplicationController
  def show
  end
  def index
    @show = Show.find(params[:show_id])
    @seasons = @show.seasons
  end
end