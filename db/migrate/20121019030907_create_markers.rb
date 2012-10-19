class CreateMarkers < ActiveRecord::Migration
  def change
    create_table :markers do |t|
      t.decimal :longitude
      t.decimal :latitude
      t.string :icon
      t.timestamps
    end
  end
end
