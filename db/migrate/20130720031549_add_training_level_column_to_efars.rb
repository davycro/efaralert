class AddTrainingLevelColumnToEfars < ActiveRecord::Migration
  def change
  	add_column :efars, :training_level, :string, :default => 'Basic'
  end
end
