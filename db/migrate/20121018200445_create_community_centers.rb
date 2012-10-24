class CreateCommunityCenters < ActiveRecord::Migration
  def change
    create_table :community_centers do |t|
      t.string :name, :null => false
      t.string :street, :null => false
      t.string :suburb
      t.string :postal_code, :null => false
      t.string :city, :null => false
      t.string :province
      t.string :country, :null => false

      t.timestamps
    end
  end
end
