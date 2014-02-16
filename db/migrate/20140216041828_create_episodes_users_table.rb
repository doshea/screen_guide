class CreateEpisodesUsersTable < ActiveRecord::Migration
  def change
    create_table :episodes_users do |t|
      t.belongs_to :episode
      t.belongs_to :user
    end
  end
end
