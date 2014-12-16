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
  has_many :watch_records, as: :watchable
  has_many :finishers, through: :watch_records, source: :user


  scope :by_number, -> { order(number: :asc) }

  has_many :episodes, -> { order(:number) }, dependent: :destroy

  def watched_by?(user)
    if show.watched_by?(user)
      show.watched_by?(user)
    elsif finishers.include?(user)
      self
    else
      false
    end
  end

  def fully_watched_by?(user)
    unwatched = episodes - user.episodes.where(season_id: id)
    unwatched.empty?
  end

end