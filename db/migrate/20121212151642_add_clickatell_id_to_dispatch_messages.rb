class AddClickatellIdToDispatchMessages < ActiveRecord::Migration
  def change
    add_column :dispatch_messages, :clickatell_id, :string
    add_index :dispatch_messages, :clickatell_id
    add_column :dispatch_messages, :clickatell_error_message, :string
  end
end
