# == Schema Information
#
# Table name: shows
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Show < ActiveRecord::Base
  has_many :seasons
  has_many :episodes, through: :seasons

end
