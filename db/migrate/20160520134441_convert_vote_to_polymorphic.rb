class ConvertVoteToPolymorphic < ActiveRecord::Migration
  def change
    remove_index :votes, :question_id
    rename_column :votes, :question_id, :votable_id

    add_column :votes, :votable_type, :string
    add_index :votes, [:votable_id, :votable_type]
  end
end
