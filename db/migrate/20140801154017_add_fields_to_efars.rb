class AddFieldsToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :dob, :date
    add_column :efars, :gender, :string
    add_column :efars, :occupation, :string
    add_column :efars, :certificate_number, :string
    add_column :efars, :module_1, :integer
    add_column :efars, :module_2, :integer
    add_column :efars, :module_3, :integer
    add_column :efars, :module_4, :integer
    add_column :efars, :cpr_competent, :boolean
  end
end
