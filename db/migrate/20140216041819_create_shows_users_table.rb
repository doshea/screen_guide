class CreateShowsUsersTable < ActiveRecord::Migration
  def change
    create_table :shows_users, id: false do |t|
      t.belongs_to :show
      t.belongs_to :user
    end
  end
end
