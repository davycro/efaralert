class RemoveHeadEfarColumn < ActiveRecord::Migration
  def up
  	remove_column :efars, :is_head_efar, :is_active
  end

  def down
  end
end
