class Admin::EpisodesController < ApplicationController
  before_filter :ensure_admin
  
  def index
    @episodes = Episode.all
  end
end
