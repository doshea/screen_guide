# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  email              :string(255)
#  username           :string(255)
#  is_admin           :boolean
#  password_digest    :string(255)
#  image              :string(255)
#  auth_token         :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  queue_oldest_first :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  has_secure_password

  has_and_belongs_to_many :followed_shows, class_name: 'Show', join_table: 'shows_users', association_foreign_key: 'show_id'
  has_and_belongs_to_many :episodes
  has_and_belongs_to_many :watched_shows, class_name: 'Show', join_table: 'watched_shows', association_foreign_key: 'show_id'
  has_and_belongs_to_many :watched_seasons, class_name: 'Season', join_table: 'watched_seasons', association_foreign_key: 'season_id'
  has_and_belongs_to_many :watched_episodes, class_name: 'Episode', join_table: 'watched_episodes', association_foreign_key: 'episode_id'

  mount_uploader :image, AccountPicUploader
  
  before_create { generate_token(:auth_token) }

  MIN_PASSWORD_LENGTH = 5
  MAX_PASSWORD_LENGTH = 16
  validates :password,
    presence: true,
    confirmation: true,
    length: { minimum: MIN_PASSWORD_LENGTH, maximum: MAX_PASSWORD_LENGTH, message: ": Should be #{MIN_PASSWORD_LENGTH}-#{MAX_PASSWORD_LENGTH} characters" },
    on: :create

  validates :password,
    confirmation: true,
    length: { minimum: MIN_PASSWORD_LENGTH, maximum: MAX_PASSWORD_LENGTH, message: ": Should be #{MIN_PASSWORD_LENGTH}-#{MAX_PASSWORD_LENGTH} characters" },
    allow_blank: true,
    on: :update

  MAX_EMAIL_LENGTH = 35
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    uniqueness: true,
    length: { maximum: MAX_EMAIL_LENGTH, message: ": That's just too long. Your email shouldn't be above #{MAX_EMAIL_LENGTH} characters" },
    format: { with: VALID_EMAIL_REGEX, message: ": Only real email addresses, please" }

  MAX_USERNAME_LENGTH = 16
  MIN_USERNAME_LENGTH = 4
  validates :username,
    presence: true,
    uniqueness: true,
    length: { minimum: MIN_USERNAME_LENGTH, maximum: MAX_USERNAME_LENGTH, message: ": Should be #{MIN_USERNAME_LENGTH}-#{MAX_USERNAME_LENGTH} characters"}

  MIN_NAME_LENGTH = 2
  validates :first_name,
    allow_blank: true,
    length: { minimum: MIN_NAME_LENGTH, message: ": Should be at least #{MIN_NAME_LENGTH} characters"}
  validates :last_name,
    allow_blank: true,
    length: { minimum: MIN_NAME_LENGTH, message: ": Should be at least #{MIN_NAME_LENGTH} characters"}

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column]) #may need a colon
  end

  def watch!(watchable)
    if watchable.is_a? Show
      watch_show! watchable
    elsif watchable.is_a? Season
      watch_season! watchable
    elsif watchable.is_a? Episode
      watch_episode! watchable
    else
      raise "That object(#{watchable}) is not a Show, Season or Episode."
    end
  end

  def watch_show!(show)
    unless has_watched? show
      watched_episodes.delete(show.episodes)
      watched_seasons.delete(show.seasons)
      watched_shows << show
    end
  end

  def watch_season!(season)
    unless has_watched? season
      sister_watched_seasons = watched_seasons.where(show_id: season.show.id)
      if season.show.seasons.count - sister_watched_seasons.count == 1
        watch_show!(season.show)
      else
        watched_episodes.delete(season.episodes)
        watched_seasons << season
      end
    end
  end

  def watch_episode!(episode)
    unless has_watched? episode
      sister_watched_episodes = watched_episodes.where(season_id: episode.season.id)
      if episode.season.episodes.count - sister_watched_episodes.count == 1
        watch_season!(episode.season)
      else
        watched_episodes << episode
      end
    end
  end

  def has_watched?(watchable)
    if watchable.is_a? Episode
      if watchable.in? watched_episodes
        return true
      else
        watchable = watchable.season
      end
    end
    if watchable.is_a? Season
      if watchable.in? watched_seasons
        return true
      else
        watchable = watchable.show
      end
    end
    if watchable.is_a? Show
      if watchable.in? watched_shows
        return true
      end
    end 
    return false
  end

  def unwatch!(watchable)
    if watchable.is_a? Show
      unwatch_show! watchable
    elsif watchable.is_a? Season
      unwatch_season! watchable
    elsif watchable.is_a? Episode
      unwatch_episode! watchable
    else
      raise "That object(#{watchable}) is not a Show, Season or Episode."
    end
  end
  def unwatch_show!(show)
    watched_shows.delete(show)
    watched_seasons.delete(show.seasons)
    watched_episodes.delete(show.episodes)
  end
  def unwatch_season!(season)
    show = season.show
    if show.in? self.watched_shows
      self.watched_shows.delete(show)
      sister_seasons = show.seasons - [season]
      self.watched_seasons += sister_seasons
    end
    self.watched_seasons.delete(season)
    self.watched_episodes.delete(season.episodes)
  end
  #TODO build this out
  def unwatch_episode!(episode)
    season = episode.season
    show = season.show
    if show.in? self.watched_shows
      self.watched_shows.delete(show)
      self.watched_seasons += show.seasons
    end
    if season.in? self.watched_seasons
      self.watched_seasons.delete(season)
      sister_episodes = season.episodes - [episode]
      self.watched_episodes += sister_episodes
    end
    self.watched_episodes.delete(episode)
  end
end
