class CreateEfars < ActiveRecord::Migration
  def change
    create_table :efars do |t|
      t.string :surname, :null => false
      t.string :first_name, :null => false
      t.string :address, :null => false
      t.string :community
      t.string :postal_code, :null => false
      t.string :city, :null => false
      t.string :province
      t.string :country, :null => false
      t.string :contact_number, :null => false
      t.string :certification_level
      t.timestamps
    end
  end
end
