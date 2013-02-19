class DropResearchers < ActiveRecord::Migration
  def up
    drop_table :researchers
  end

  def down
  end
end
