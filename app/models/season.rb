# == Schema Information
#
# Table name: seasons
#
#  id         :integer          not null, primary key
#  number     :integer
#  show_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Season < ActiveRecord::Base
  belongs_to :show
  has_many :episodes, -> { order(:number) }, dependent: :destroy

  has_and_belongs_to_many :watchers, class_name: 'User', join_table: 'watched_seasons', association_foreign_key: 'user_id'

  scope :by_number, -> { order(number: :asc) }


  def watched_by?(user)
    if show.watched_by?(user)
      show.watched_by?(user)
    elsif finishers.include?(user)
      self
    else
      false
    end
  end

  def add_episode(ep)
    episodes << ep
    new_number = ep.number
    lower_eps = episodes.where('number < ?', new_number)
    finishers.each do |finisher|
      
    end
  end

  def fully_watched_by?(user)
    unwatched = episodes - user.episodes.where(season_id: id)
    unwatched.empty?
  end

end