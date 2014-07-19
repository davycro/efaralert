class AddControlGroupColumnToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :control_group, :boolean, :default => false
  end
end
