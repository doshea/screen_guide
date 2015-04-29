# == Schema Information
#
# Table name: episodes
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  number     :integer
#  air_date   :date
#  season_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Episode < ActiveRecord::Base
  belongs_to :season

  has_one :show, through: :season

  has_and_belongs_to_many :users #TODO: remove this in favor of watchers
  has_and_belongs_to_many :watchers, class_name: 'User', join_table: 'watched_episodes', association_foreign_key: 'user_id'

  scope :by_number, -> { order(number: :asc) }
  scope :by_air_date, -> { order(air_date: :asc, number: :asc) }

  validates_presence_of :air_date, :number, :title, :season_id

  def torrent_link
    "http://www.google.com/#q=#{show.nickname_or_name}+torrent+#{shorthand}"
  end
  def kickass_link
    "https://kickass.to/usearch/#{show.nickname_or_name} #{shorthand}"
  end
  def hulu_link
    phrase = "#{show.nickname_or_name} season #{season.number} episode #{number}".gsub(' ','+')
    "http://www.hulu.com/search?q=#{phrase}&type=episodes"
  end
  def netflix_link
    "http://www.netflix.com/search/#{show.nickname_or_name}"
  end

  def watched_by?(user)
    if season.watched_by?(user)
      season.watched_by?(user)
    elsif users.include?(user)
      self
    else
      false
    end
  end

  private
  def shorthand
    "s#{'%02d' % season.number}e#{'%02d' % number}"
  end

end