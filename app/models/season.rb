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

  scope :by_number, -> { order(number: :asc) }

  has_many :episodes, -> { order(:number) }, dependent: :destroy

end
