class AddPasswordFieldToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :password_digest, :string
  end
end
