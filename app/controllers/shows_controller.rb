class ShowsController < ApplicationController
  def index
    @active = Show.active
    @inactive = Show.inactive
  end

  def show
    @show = Show.includes(seasons: :episodes).find(params[:id])
  end
end