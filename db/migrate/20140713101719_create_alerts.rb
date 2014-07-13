class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :given_location
      t.string :landmarks
      t.string :incident_type
      t.float :lat
      t.float :lng
      t.string :formatted_address
      t.string :location_type
      t.timestamps
    end
  end
end
