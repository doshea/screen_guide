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

end