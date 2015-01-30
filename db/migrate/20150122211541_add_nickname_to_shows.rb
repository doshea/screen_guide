class AddNicknameToShows < ActiveRecord::Migration
  def change
    add_column :shows, :nickname, :string
  end
end
