class RemoveSuperflouousEfarAttributes < ActiveRecord::Migration
  def names_of_columns_to_be_removed
    %w(training_date training_location training_score training_instructor
      birthday profile)  
  end

  def up
    self.names_of_columns_to_be_removed.each do |column_name|
      remove_column :efars, column_name.to_sym
    end
  end

  def down
    raise "cannot be reversed!"
  end
end
