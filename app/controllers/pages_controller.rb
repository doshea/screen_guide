class PagesController < ApplicationController
  def index
    @shows = Show.all
  end
end