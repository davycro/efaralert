class CreateDispatchers < ActiveRecord::Migration
  def change
    create_table :dispatchers do |t|
      t.string :full_name, :null => false
      t.string :username, :null => false
      t.string :password_digest, :null => false
      t.timestamps
    end
    add_index :dispatchers, :username, :unique => true
  end
end
