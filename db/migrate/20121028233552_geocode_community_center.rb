class GeocodeCommunityCenter < ActiveRecord::Migration
  def up
    add_column :community_centers, :lat, :float
    add_column :community_centers, :lng, :float
    add_column :community_centers, :location_type, :string
    add_column :community_centers, :formatted_address, :string
  end

  def down
    remove_column :community_centers, :lat
    remove_column :community_centers, :lng
    remove_column :community_centers, :location_type
    remove_column :community_centers, :formatted_address
  end
end
