class CreateGeolocations < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.integer :dispatcher_id, :null => false
      t.string :emergency_category
      t.integer :geolocation_id
      t.integer :township_id
      t.string :township_house_number
      t.string :landmarks

      t.float :lat
      t.float :lng
      t.string :formatted_address
      t.string :location_type

      t.timestamps
    end
    
    create_table :townships do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
