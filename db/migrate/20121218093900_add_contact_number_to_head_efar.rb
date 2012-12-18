class AddContactNumberToHeadEfar < ActiveRecord::Migration
  def change
    add_column :head_efars, :contact_number, :string, :null => false
  end
end
