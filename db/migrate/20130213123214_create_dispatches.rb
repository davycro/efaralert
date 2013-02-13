class CreateDispatches < ActiveRecord::Migration
  def change
    create_table :dispatches do |t|
      t.integer :dispatcher_id, :null => false
      t.string :emergency_category
      t.integer :geolocation_id
      t.integer :township_id
      t.string :landmarks

      t.timestamps
    end
  end
end
