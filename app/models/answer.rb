class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  default_scope { order(accepted: :desc) }

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update_attribute(:accepted, true)
    end
  end
end
