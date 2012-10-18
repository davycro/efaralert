class CreateHeadEfars < ActiveRecord::Migration
  def change
    create_table :head_efars do |t|
      t.string :full_name, :null => false
      t.integer :community_center_id, :null => false
      t.string :email, :null => false
      t.string :password_digest, :null => false

      t.timestamps
    end

    add_index :head_efars, :email, :unique => true
  end
end
