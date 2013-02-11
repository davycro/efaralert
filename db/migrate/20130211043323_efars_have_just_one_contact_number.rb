class EfarsHaveJustOneContactNumber < ActiveRecord::Migration
  def up
    Efar.destroy_all
    add_column :efars, :contact_number, :string, :null => false
    drop_table :efar_contact_numbers
  end

  def down
  end
end
