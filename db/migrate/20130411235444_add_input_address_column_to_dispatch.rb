class AddInputAddressColumnToDispatch < ActiveRecord::Migration

  def change
    add_column :dispatches, :input_address, :string
  end
end
