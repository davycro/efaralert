class RemoveGeolocationColumnFromDispatchModel < ActiveRecord::Migration
  def up
    remove_column :dispatches, :geolocation_id
  end

  def down
  end
end
