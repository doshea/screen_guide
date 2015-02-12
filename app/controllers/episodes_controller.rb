class EpisodesController < ApplicationController
  def show
    @episode = Episode.find(params[:id])
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
    render nothing: true
  end
end