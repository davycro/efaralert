class CreateCandidateEfars < ActiveRecord::Migration
  def change
    create_table :candidate_efars do |t|
      t.string :full_name, :null => false
      t.string :full_address
      t.string :contact_number, :null => false
      t.integer :community_center_id, :null => false
      t.string :training_score
      t.timestamps
      t.string :first_invite_status_part_one
      t.string :first_invite_status_part_two
    end
  end
end
