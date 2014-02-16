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

  has_many :episodes

  default_scope { order(number: :asc) }

end
