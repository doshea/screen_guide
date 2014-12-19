class PagesController < ApplicationController
  def index
    if @current_user
      redirect_to shows_path
    else
      @shows = Show.all
    end
  end
end