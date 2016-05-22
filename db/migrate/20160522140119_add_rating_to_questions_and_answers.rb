class AddRatingToQuestionsAndAnswers < ActiveRecord::Migration
  def up
    add_column :answers, :rating, :integer, default: 0
    add_column :questions, :rating, :integer, deafult: 0

    Answer.find_each do |answer|
      answer.update(rating: answer.votes.pluck(:value).inject(0, :+))
    end
    Question.find_each do |question|
      question.update(rating: question.votes.pluck(:value).inject(0, :+))
    end
  end

  def down
    remove_column :answers, :rating
    remove_column :questions, :rating
  end
end
