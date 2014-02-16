class Admin::SeasonsController < ApplicationController
  before_filter :ensure_admin

  def new
    @show = Show.find(params[:show_id])
    @season = Season.new
  end

  def create
    @show = Show.find(params[:show_id])
    @season = Season.new(admin_season_params)
    if @show
      @show.seasons << @season
      redirect_to @show
    end
  end

  private ###
  def admin_season_params
    params.require(:season).permit(:number)
  end

end