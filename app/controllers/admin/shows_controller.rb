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
    new_show_data = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{params[:rage_id]}")
    symbolize_and_downcase_keys_deep!(new_show_data)
    new_show_data = new_show_data[:show]
    new_show = Show.create(
      name: new_show_data[:name],
      rage_id: params[:rage_id]
    )
    total_seasons = new_show_data[:totalseasons].to_i

    (1..total_seasons).each do |i|
      new_season = Season.create(number: i)
      new_show.seasons << new_season
      if total_seasons > 1
        temp_episodes = new_show_data[:episodelist][:season][i-1][:episode]
      else
        temp_episodes = new_show_data[:episodelist][:season][:episode]
      end
      if temp_episodes.class != Array
        temp_episodes = [temp_episodes]
      end
      temp_episodes.each do |temp_episode|
        new_episode = Episode.create(
          number: temp_episode[:seasonnum].to_i,
          air_date: Date.parse(temp_episode[:airdate]),
          title: temp_episode[:title]
        )
        new_season.episodes << new_episode
      end
    end
    redirect_to new_show
  end

  def check_for_new_episodes
    show = Show.find(params[:id])
    rage_data = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{show.rage_id}")
    symbolize_and_downcase_keys_deep!(rage_data)
    show_data = rage_data[:show]

    total_seasons = show_data[:totalseasons].to_i
    existing_seasons = show.seasons

    seasons_added = false
    episodes_added = false

    if total_seasons > existing_seasons.count
      (existing_seasons.count+1..total_seasons).each do |i|
        show.seasons << Season.create(number: i)
        seasons_added = (seasons_added or 0) +1
      end
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
    redirect_to @show
  end

  def destroy
    show = Show.find(params[:id])
    show.destroy
    redirect_to shows_path
  end

  private ###
  def admin_show_params
    params.require(:show).permit(:name, :active, :image, :rage_id)
  end
  def rage_show_params
    params.require(:show).permit(:name, :rage_id)
  end

  def symbolize_and_downcase_keys_deep!(h)
    puts "#{h.class} -- #{h}" 
    if h.kind_of? Hash
      h.keys.each do |k|
        ks    = k.respond_to?(:to_sym) ? k.downcase.to_sym : k
        h[ks] = h.delete k # Preserve order even when k == ks
        symbolize_and_downcase_keys_deep! h[ks] if ((h[ks].kind_of? Hash) or (h[ks].kind_of? Array))
      end
    elsif h.kind_of? Array
      puts 'Array!'
      h.each do |el|
        symbolize_and_downcase_keys_deep! el if (el.kind_of? Hash or el.kind_of? Array)
      end
    end
  end

end
