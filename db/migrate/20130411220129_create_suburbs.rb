class CreateSuburbs < ActiveRecord::Migration
  def change
    create_table :suburbs do |t|
      t.string :name, :null => false
      t.float :lat
      t.float :lng
      t.string :formatted_address
      t.string :location_type
      t.timestamps
    end
  end
end
