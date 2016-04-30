class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, :user_id, presence: true

  def answers
    Answer.where(question_id: self.id)
  end
end
