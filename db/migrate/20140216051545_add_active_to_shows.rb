class AddActiveToShows < ActiveRecord::Migration
  def change
    add_column :shows, :active, :boolean, default: false
  end
end
