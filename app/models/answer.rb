class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  default_scope { order(accepted: :desc) }

  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  after_create :notify_question_subscribers

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update_attribute(:accepted, true)
    end
  end

  private

  def notify_question_subscribers
    NotifySubscribersJob.perform_later(self, question)
  end
end
