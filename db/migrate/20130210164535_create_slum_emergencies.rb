class CreateSlumEmergencies < ActiveRecord::Migration
  def change
    create_table :slum_emergencies do |t|
      t.integer :slum_id, :null => false
      t.string :category
      t.string :shack_number
      t.integer :dispatcher_id, :null => false

      t.timestamps
    end
  end
end
