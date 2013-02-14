class DeprecateEmergencyTables < ActiveRecord::Migration
  def up
    drop_table :emergencies
    drop_table :slum_emergencies
    drop_table :slums
    drop_table :slum_dispatch_messages
  end

  def down
  end
end
