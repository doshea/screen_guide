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

  has_and_belongs_to_many :users

  scope :by_number, -> { order(number: :asc) }
  scope :by_air_date, -> { order(air_date: :desc) }

  def torrent_link
    "http://www.google.com/#q=#{self.show.name}+torrent+s#{'%02d' % self.season.number}e#{'%02d' % self.number}"
  end

end