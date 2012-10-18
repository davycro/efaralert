class CreateResearchers < ActiveRecord::Migration
  def change
    create_table :researchers do |t|
      t.string :full_name, :null => false
      t.string :email, :null => false
      t.string :affiliation
      t.string :password_digest, :null => false

      t.timestamps
    end

    add_index :researchers, :email, :unique => true
  end
end
