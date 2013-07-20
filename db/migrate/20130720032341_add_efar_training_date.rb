class AddEfarTrainingDate < ActiveRecord::Migration
  def up
  	add_column :efars, :training_date, :date
  end

  def down
  	# remove_column :efars, :training_date
  end
end
