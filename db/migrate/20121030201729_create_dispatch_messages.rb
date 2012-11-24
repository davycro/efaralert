class CreateDispatchMessages < ActiveRecord::Migration
  def change
    create_table :dispatch_messages do |t|
      t.integer :emergency_id, :null => false
      t.integer :efar_id, :null => false
      t.string :state
      t.timestamps
    end
  end
end
