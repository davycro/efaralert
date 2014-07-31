class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.string :full_name, :null => false
      t.string :username, :null => false
      t.string :password_digest, :null => false
      t.integer :community_center_id, :null => false
      t.timestamps
    end
  end
end
