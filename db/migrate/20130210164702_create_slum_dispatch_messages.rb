class CreateSlumDispatchMessages < ActiveRecord::Migration
  def change
    create_table :slum_dispatch_messages do |t|
      t.integer :slum_emergency_id, :null => false
      t.integer :efar_id, :null => false
      t.string :clickatell_error_message
      t.string :state, :default => 'queued'

      t.timestamps
    end
  end
end
