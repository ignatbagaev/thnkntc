class Answer < ActiveRecord::Base
  default_scope { order(accepted: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
end
