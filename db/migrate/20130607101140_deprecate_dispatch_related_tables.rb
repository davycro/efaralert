class DeprecateDispatchRelatedTables < ActiveRecord::Migration
  def up
    drop_table :dispatchers
    drop_table :suburbs
    drop_table :candidate_efars
  end

  def down
    raise "No going back!"
  end
end
