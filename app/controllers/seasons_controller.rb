class SeasonsController < ApplicationController
  def show
    @season = Season.find(params[:id])
  end
  def index
    @show = Show.includes(:seasons).find(params[:show_id])
    @seasons = @show.seasons
  end
end