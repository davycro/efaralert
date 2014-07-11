class CreateStudyInvites < ActiveRecord::Migration
  def change
    create_table :study_invites do |t|
      t.integer :efar_id, :null => false
      t.boolean :accepted, :default => false

      t.timestamps
    end
    add_column :efars, :study_invite_id, :integer
  end
end
