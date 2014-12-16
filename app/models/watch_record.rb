# == Schema Information
#
# Table name: watch_records
#
#  user_id        :integer
#  watchable_id   :integer
#  watchable_type :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class WatchRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :watchable, polymorphic: true
end
