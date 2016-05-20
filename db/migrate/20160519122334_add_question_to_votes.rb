class AddQuestionToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :question_id, :integer
    add_index :votes, :question_id
  end
end
