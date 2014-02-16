class Admin::EpisodesController < ApplicationController
  before_filter :ensure_admin

  def new
    @season = Season.find(params[:season_id])
    @num_guess = ((@season.episodes.map{|e| e.number}.max)|| 0)
    @week_guess = (@season.episodes.map{|e| e.air_date}.max )
    @episode = Episode.new
  end

  def create
    @season = Season.find(params[:season_id])
    @episode = Episode.new(admin_episode_params)
    if @season
      @season.episodes << @episode
      redirect_to @season
    end
  end

  private ###
  def admin_episode_params
    params.require(:episode).permit(:title, :number, :air_date)
  end
  
end
