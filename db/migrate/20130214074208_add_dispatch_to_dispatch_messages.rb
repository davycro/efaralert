class AddDispatchToDispatchMessages < ActiveRecord::Migration
  def change
    remove_column :dispatch_messages, :emergency_id
    remove_column :dispatch_messages, :efar_location_id
    add_column :dispatch_messages, :dispatch_id, :integer, :null => false
    add_column :dispatch_messages, :efar_location_id, :integer
  end
end
