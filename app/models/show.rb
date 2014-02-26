# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  image      :text
#  active     :boolean          default(FALSE)
#  rage_id    :integer
#

class Show < ActiveRecord::Base
  has_many :seasons, dependent: :destroy
  has_many :episodes, through: :seasons

  has_and_belongs_to_many :users

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  validates :name,
    uniqueness: true

  def year_range
    air_dates = self.episodes.map{|e| e.air_date}.sort
    if air_dates.empty?
      "(TBA)"
    else
      start_year = air_dates.first.year
      end_year = air_dates.last.year
      if self.active?
        end_range = ' - '
      elsif end_year == start_year
        end_range = ''
      else
        end_range = " - #{end_year}"
      end
      "(#{start_year}#{end_range})"
    end
  end

  def check_for_new_episodes
    rage_data = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{self.rage_id}")
    Show.symbolize_and_downcase_keys_deep!(rage_data)
    show_data = rage_data[:show]

    total_seasons = show_data[:totalseasons].to_i
    existing_seasons = self.seasons

    seasons_added = false
    episodes_added = false
    episodes_updated = false
    episodes_unchanged = false

    # Adds any missing seasons
    if total_seasons > existing_seasons.count
      (existing_seasons.count+1..total_seasons).each do |i|
        self.seasons << Season.create(number: i)
        seasons_added = (seasons_added or 0) + 1
      end
    end

    #
    if total_seasons > 1
      seasons = show_data[:episodelist][:season]
    else
      one_season = show_data[:episodelist][:season]
      seasons = [one_season]
    end

    seasons.each do |season|
      season_number = season[:no].to_i
      existing_season = self.seasons.find_by_number(season_number)
      episodes = ((season[:episode].class == Array) ? season[:episode] : [season[:episode]])
      episodes.each do |episode|
        existing_episode = existing_season.episodes.find_by_number(episode[:seasonnum].to_i)
        if existing_episode
          ep_updated = false
          if existing_episode.title != episode[:title]
            puts "Episode #{existing_episode.number} of Season #{season_number} of '#{self.name}' was updated with new title '#{episode[:title]}' from '#{existing_episode.title}'"
            existing_episode.update_attribute(:title, episode[:title])
            ep_updated = true
          end
          if existing_episode.air_date != Date.parse(episode[:airdate])
            puts "Episode #{existing_episode.number} of Season #{season_number} of '#{self.name}' was updated with new air date #{episode[:airdate]} from #{existing_episode.air_date}"
            existing_episode.update_attribute(:air_date, Date.parse(episode[:airdate]))
            ep_updated = true
          end
          if ep_updated
            episodes_updated = (episodes_updated or 0) + 1
          else
            episodes_unchanged = (episodes_unchanged or 0) + 1
          end
        else
          new_episode = Episode.create(number: episode[:seasonnum], title: episode[:title], air_date: episode[:airdate])
          existing_season.episodes << new_episode
          puts "Added an episode to Season #{season_number} of #{self.name}: '#{new_episode.title}', aired #{new_episode.air_date} as Episode #{new_episode.number} of the season."
          episodes_added = (episodes_added or 0) + 1
        end
      end
    end

    # Reports on what has been done
    puts seasons_added ? "Added #{seasons_added} #{'seasons'.pluralize(seasons_added)}." : 'Seasons were up-to-date.'
    puts episodes_added ? "Added #{episodes_added} #{'episode'.pluralize(episodes_added)}." : 'Episodes were not created.'
    puts episodes_updated ? "Updated #{episodes_updated} #{'episode'.pluralize(episodes_updated)}." : 'Episodes not updated.'
    puts episodes_unchanged ? "#{episodes_unchanged} #{'Episode'.pluralize(episodes_unchanged)} unchanged." : "All episodes changed for '{self.title}'!!!"

  end

  def self.rage_create(rage_id)
    new_show_data = HTTParty.get("http://services.tvrage.com/feeds/episode_list.php?sid=#{rage_id}")
    Show.symbolize_and_downcase_keys_deep!(new_show_data)
    new_show_data = new_show_data[:show]
    new_show = Show.create(
      name: new_show_data[:name],
      rage_id: rage_id
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
    new_show
  end

  private
  def self.symbolize_and_downcase_keys_deep!(h)
    if h.kind_of? Hash
      h.keys.each do |k|
        ks    = k.respond_to?(:to_sym) ? k.downcase.to_sym : k
        h[ks] = h.delete k # Preserve order even when k == ks
        symbolize_and_downcase_keys_deep! h[ks] if ((h[ks].kind_of? Hash) or (h[ks].kind_of? Array))
      end
    elsif h.kind_of? Array
      h.each do |el|
        symbolize_and_downcase_keys_deep! el if (el.kind_of? Hash or el.kind_of? Array)
      end
    end
  end

end
