class CreateWatchedShowsAndWatchesSeasonsAndWatchedEpisodes < ActiveRecord::Migration
  def change
    drop_table :watch_records, id: false do |t|
      t.belongs_to :user
      t.references :watchable, polymorphic: true
      t.timestamps
    end
    create_table :watched_shows, id: false do |t|
      t.belongs_to :user
      t.belongs_to :show
    end
    create_table :watched_seasons, id: false do |t|
      t.belongs_to :user
      t.belongs_to :season
    end
    create_table :watched_episodes, id: false do |t|
      t.belongs_to :user
      t.belongs_to :episode
    end
  end
end
