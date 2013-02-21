class RemoveEfarLocations < ActiveRecord::Migration
  def up
    drop_table :efar_locations
  end

  def down
  end
end
