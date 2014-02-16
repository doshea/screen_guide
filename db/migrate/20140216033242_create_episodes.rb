class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.integer :number
      t.date :air_date

      t.belongs_to :season

      t.timestamps
    end
  end
end