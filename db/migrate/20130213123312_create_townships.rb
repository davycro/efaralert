class CreateTownships < ActiveRecord::Migration
  def change
    create_table :townships do |t|
      t.string :name, :null => false

      t.timestamps
    end
  end
end
