class AddAnotherInviteRoundToCandidateEfars < ActiveRecord::Migration
  def change
    add_column :candidate_efars, :second_invite_part_one, :string
    add_column :candidate_efars, :second_invite_part_two, :string
    add_column :candidate_efars, :third_invite_part_one, :string
    add_column :candidate_efars, :third_invite_part_two, :string
  end
end
