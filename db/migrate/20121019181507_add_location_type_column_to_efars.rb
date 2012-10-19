class AddLocationTypeColumnToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :location_type, :string, :default => "NO_LOCATION"
    add_column :efars, :formatted_address, :string
  end
end
