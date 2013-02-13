class AddLandmarksToSlumEmergencies < ActiveRecord::Migration
  def change
    add_column :emergencies, :landmarks, :string
    add_column :slum_emergencies, :landmarks, :string
  end
end
