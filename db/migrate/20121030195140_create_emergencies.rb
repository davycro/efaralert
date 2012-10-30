class CreateEmergencies < ActiveRecord::Migration
  def change
    create_table :emergencies do |t|
      t.integer :dispatcher_id, :null => false
      t.string :input_address, :null => false
      t.string :category
      t.string :formatted_address
      t.float :lat, :null => false
      t.float :lng, :null => false
      t.string :location_type
      t.timestamps
    end
  end
end
