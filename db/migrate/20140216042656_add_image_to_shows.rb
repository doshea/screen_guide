class AddImageToShows < ActiveRecord::Migration
  def change
    add_column :shows, :image, :text
  end
end
