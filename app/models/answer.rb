class Answer < ActiveRecord::Base
  default_scope { order(status: :desc) }

  enum status: { common: 0, accepted: 1 }

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
end
