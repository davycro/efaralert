class CreateGeolocations < ActiveRecord::Migration
  def change
    create_table :geolocations do |t|
      t.float :lat, :null => false
      t.float :lng, :null => false
      t.string :formatted_address, :null => false
      t.string :location_type

      t.timestamps
    end
  end
end
