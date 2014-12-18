class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
  end
  def index
    @season = Season.find(params[:season_id])
    @episodes = @season.episodes.by_number
  end
  def watch
    if @current_user
      @episode = Episode.find(params[:id])
      if params[:watched] == 'true'
        @current_user.episodes << @episode unless @current_user.episodes.include?(@episode)
      else
        @current_user.episodes.delete(@episode)
      end
    end
    if params[:return]
      render :queue_watch
    else
      render nothing: true
    end
  end
end