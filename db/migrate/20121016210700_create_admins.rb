class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :full_name, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false

      t.timestamps
    end

    add_index :admins, :email, :unique => true
  end
end
