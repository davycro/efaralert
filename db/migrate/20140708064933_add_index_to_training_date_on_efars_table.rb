class AddIndexToTrainingDateOnEfarsTable < ActiveRecord::Migration
  def change
    add_index :efars, :training_date
  end
end
