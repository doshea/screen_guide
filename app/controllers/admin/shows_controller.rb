class Admin::ShowsController < ApplicationController
  before_filter :ensure_admin

  def new
    @show = Show.new
  end

  def create 
    @show = Show.new(admin_show_params)
    if @show.save
      redirect_to @show
    else
      render :new
    end
    
  end

  def edit
    @show = Show.find(params[:id])
  end

  def update
    @show = Show.find(params[:id])
    if @show
      @show.update_attributes(admin_show_params)
    end
    redirect_to :back
  end

  private ###
  def admin_show_params
    params.require(:show).permit(:name, :active, :image)
  end

end