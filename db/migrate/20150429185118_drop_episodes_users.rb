class DropEpisodesUsers < ActiveRecord::Migration
  def change
    drop_table :episodes_users, id: false do |t|
      t.belongs_to :episode
      t.belongs_to :user
    end
  end
end
