class AddRageIdToShows < ActiveRecord::Migration
  def change
    add_column :shows, :rage_id, :integer
  end
end
