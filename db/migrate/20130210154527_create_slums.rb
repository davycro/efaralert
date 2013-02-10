class CreateSlums < ActiveRecord::Migration
  def change
    create_table :slums do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_column :efars, :slum_id, :integer
  end
end
