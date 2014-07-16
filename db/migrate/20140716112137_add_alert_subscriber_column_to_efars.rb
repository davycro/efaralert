class AddAlertSubscriberColumnToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :alert_subscriber, :boolean, :default => false
  end
end
