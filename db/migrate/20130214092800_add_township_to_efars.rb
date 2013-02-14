class AddTownshipToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :township_id, :integer
    remove_column :efars, :slum_id
  end
end
