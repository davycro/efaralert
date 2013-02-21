class RemoveEfarLocationIdFromDispatchMessages < ActiveRecord::Migration
  def up
    remove_column :dispatch_messages, :efar_location_id
  end

  def down
  end
end
