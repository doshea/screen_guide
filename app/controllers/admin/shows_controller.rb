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

  def rage_create
    new_show = Show.rage_create(params[:rage_id])
    redirect_to new_show
  end

  def check_for_new_episodes
    show = Show.find(params[:id])
    show.check_for_new_episodes
    redirect_to show
  end

  def edit
    @show = Show.find(params[:id])
  end

  def update
    @show = Show.find(params[:id])
    if @show
      @show.update_attributes(admin_show_params)
    end
    redirect_to @show
  end

  def destroy
    show = Show.find(params[:id])
    show.destroy
    redirect_to shows_path
  end

  private ###
  def admin_show_params
    params.require(:show).permit(:name, :active, :image, :rage_id, :remote_image_url)
  end
  def rage_show_params
    params.require(:show).permit(:name, :rage_id)
  end

end
