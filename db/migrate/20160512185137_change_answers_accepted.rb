class ChangeAnswersAccepted < ActiveRecord::Migration
  def up
    add_column :answers, :accepted, :boolean, default: false
    Answer.find_each do |answer|
      answer.accepted = answer.status == 1
      answer.save
    end
    remove_column :answers, :status
  end

  def down
    add_column :answers, :status, :integer, default: 0
    Answer.find_each do |answer|
      answer.status = answer.accepted? ? 1 : 0
      answer.save
    end
    remove_column :answers, :accepted
  end
end
