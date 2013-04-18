class EfarsV2 < ActiveRecord::Migration
  def up
    add_column :efars, :given_address, :string
    add_column :efars, :is_head_efar, :boolean, :default => false
    remove_column :efars, :township_id
    remove_column :efars, :township_house_number
  end

  def down
  end
end
