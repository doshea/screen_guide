class ShowsController < ApplicationController
  def index
    @active = Show.active
    @inactive = Show.inactive
  end
end