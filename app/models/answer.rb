class Answer < ActiveRecord::Base
  default_scope { order(accepted: :desc) }

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  def accept!
    transaction do
      question.answers.where(accepted: true).update_all(accepted: false)
      update_attribute(:accepted, true)
    end
  end

  def rating
    "rating: #{positive_votes - negative_votes}"
  end

  private

  def positive_votes
    votes.where(positive: true).count
  end

  def negative_votes
    votes.where(positive: false).count
  end
end
