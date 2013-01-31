class UpdateEfarTable < ActiveRecord::Migration
  def up
    create_table :efars, :force => true do |t|
      t.string 'full_name', :null => false
      t.integer 'community_center_id', :null => false
    end
    create_table :efar_locations, :force => true do |t|
      t.integer 'efar_id', :null => false
      t.string 'occupied_at'
      t.string 'given_address', :null => false
      t.string 'formatted_address', :null => false
      t.float 'lat', :null => false
      t.float 'lng', :null => false
      t.string 'location_type'
    end
    create_table :efar_contact_numbers, :force => true do |t|
      t.integer 'efar_id', :null => false
      t.string 'contact_number', :null => false
    end
  end

  def down
    raise "do you really want to drop these tables?"
  end
end
