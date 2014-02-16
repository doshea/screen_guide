class Admin::ShowsController < ApplicationController
  before_filter :ensure_admin

  def index
    @shows = Show.all
  end
end