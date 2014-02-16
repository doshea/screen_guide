class Admin::SeasonsController < ApplicationController
  before_filter :ensure_admin

  def index
    @seasons = Season.all.includes(:episodes)
  end
end