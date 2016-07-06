class AddDefaultRatingToQuestions < ActiveRecord::Migration
  def up
    change_column_default :questions, :rating, 0

    Question.where(rating: nil).update_all(rating: 0)
  end
  def down
    #do nothing
  end
end
