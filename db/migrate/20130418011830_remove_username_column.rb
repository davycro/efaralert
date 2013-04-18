class RemoveUsernameColumn < ActiveRecord::Migration
  def up
    remove_column :dispatchers, :username
  end

  def down
  end
end
