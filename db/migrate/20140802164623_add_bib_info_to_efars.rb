class AddBibInfoToEfars < ActiveRecord::Migration
  def change
    add_column :efars, :has_bib, :boolean, :default => false
  end
end
