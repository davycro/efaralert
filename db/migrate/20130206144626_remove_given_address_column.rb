class RemoveGivenAddressColumn < ActiveRecord::Migration
  def up
    remove_column :efar_locations, :given_address
  end

  def down
  end
end
