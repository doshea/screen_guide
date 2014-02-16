# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  image      :text
#

class Show < ActiveRecord::Base
  has_many :seasons
  has_many :episodes, through: :seasons

  has_and_belongs_to_many :users

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

end
