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
#

class Show < ActiveRecord::Base
  has_many :seasons
  has_many :episodes, through: :seasons

  has_and_belongs_to_many :users

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

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

end
