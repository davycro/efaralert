class RedoEfarTable < ActiveRecord::Migration
  def up
    create_table 'efars', :force => true do |t|
      t.string :surname, :null => false
      t.string :first_name, :null => false
      t.integer :community_center_id, :null => false
      t.string :contact_number, :null => false
      t.string :street, :null => false
      t.string :suburb
      t.string :postal_code
      t.string :city, :null => false
      t.string :province
      t.string :country, :null => false
      t.float :lat
      t.float :lng
      t.string :location_type
      t.string :first_language
      t.datetime :created_at, :null => false
      t.datetime :updated_at, :null => false
    end
  end

  def down
    drop_table 'efars'
  end
end
