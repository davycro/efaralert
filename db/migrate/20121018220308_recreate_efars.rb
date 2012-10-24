class RecreateEfars < ActiveRecord::Migration
  def up
    create_table :efars do |t|
      t.string  :surname, :null => false
      t.string  :first_names, :default => "Anon"
      t.integer :community_center_id, :null => false
      t.string  :contact_number
      
      t.string  :street, :null => false
      t.string  :suburb
      t.string  :postal_code
      t.string  :city, :null => false
      t.string  :province
      t.string  :country, :null => false
      t.float :lat
      t.float :lng
      t.string  :location_type
      t.string  :formatted_address

      t.string  :first_language
      t.date    :birthday
      t.string  :profile

      t.date    :training_date
      t.float   :training_score
      t.string  :training_location
      t.string  :training_instructor

      t.timestamps
    end
  end

  def down
    drop_table :efars
  end
end
