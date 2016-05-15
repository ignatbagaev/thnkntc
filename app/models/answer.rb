class Answer < ActiveRecord::Base
  default_scope { order(accepted: :desc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update_attribute(:accepted, true)
    end
  end
end
