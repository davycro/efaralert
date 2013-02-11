class RemoveHeadEfarLoginAttributes < ActiveRecord::Migration
  def up
    remove_column :head_efars, :email
    remove_column :head_efars, :password_digest
  end

  def down
  end
end
