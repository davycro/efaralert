class AddEfarLocationToDispatchMessages < ActiveRecord::Migration
  def change
    add_column :dispatch_messages, :efar_location_id, :integer, :null => false
  end
end
