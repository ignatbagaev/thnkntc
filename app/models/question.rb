class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, :user_id, presence: true

  def has_accepted_answer?
    self.answers.pluck(:status).include? 1
  end
end
