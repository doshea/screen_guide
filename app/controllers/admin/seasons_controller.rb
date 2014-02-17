class Admin::SeasonsController < ApplicationController
  before_filter :ensure_admin

  def new
    @show = Show.find(params[:show_id])
    @num_guess = ((@show.seasons.map{|e| e.number}.max)|| 0)
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

  def edit
    @season = Season.find(params[:id])
  end

  def update
    @season = Season.find(params[:id])
    if @season
      @season.update_attributes(admin_season_params)
    end
    redirect_to @season
  end

  def destroy
    season = Season.find(params[:id])
    season.destroy
  end

  private ###
  def admin_season_params
    params.require(:season).permit(:number)
  end

end