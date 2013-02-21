class AddGeolocationToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :lat, :float
    add_column :efars, :lng, :float
    add_column :efars, :formatted_address, :string
    add_column :efars, :location_type, :string
  end
end
