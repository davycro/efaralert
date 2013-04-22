class AddActiveStatusToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :is_active, :boolean, :default => false
  end
end
