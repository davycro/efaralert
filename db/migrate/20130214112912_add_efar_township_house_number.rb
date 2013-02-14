class AddEfarTownshipHouseNumber < ActiveRecord::Migration
  def up
    add_column :efars, :township_house_number, :string
  end

  def down
  end
end
