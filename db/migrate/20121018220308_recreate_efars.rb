class RecreateEfars < ActiveRecord::Migration
  def up
    create_table :efars do |t|
      t.string :surname, :null => false
      t.string :first_names, :default => "Anon"
      t.integer :community_center_id, :null => false
      t.string :contact_number, :null => false
      t.string :certification_level
      t.string :address, :null => false
      t.string :suburb
      t.string :postal_code
      t.string :city, :null => false
      t.string :province
      t.string :country, :null => false
      t.string :lat
      t.string :long
      t.boolean :invalid_address, :default => false
      t.boolean :is_mobile, :default => false
      t.timestamps
    end
  end

  def down
    drop_table :efars
  end
end
