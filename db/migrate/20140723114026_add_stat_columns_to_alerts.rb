class AddStatColumnsToAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :distance_of_nearest_efar, :float, :default => nil # distance of nearest efar
  end
end
