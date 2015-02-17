class PagesController < ApplicationController
  def index
    if @current_user
      redirect_to shows_path
    else
      @shows = Show.all
    end
  end

  def live_search
    max_results = 15
    query = params[:query]
    @shows = Show.starts_with(query).limit(max_results)
  end
end