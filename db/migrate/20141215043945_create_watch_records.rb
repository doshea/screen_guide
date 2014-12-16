class CreateWatchRecords < ActiveRecord::Migration
  def change
    create_table :watch_records, id: false do |t|
      t.belongs_to :user
      t.references :watchable, polymorphic: true
      t.timestamps
    end
  end
end
