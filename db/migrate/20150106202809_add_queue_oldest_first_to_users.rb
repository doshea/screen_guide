class AddQueueOldestFirstToUsers < ActiveRecord::Migration
  def change
    add_column :users, :queue_oldest_first, :boolean, default: true
  end
end
