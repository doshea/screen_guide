class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :number

      t.belongs_to :show

      t.timestamps
    end
  end
end
