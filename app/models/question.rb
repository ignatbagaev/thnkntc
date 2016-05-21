class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  def has_accepted_answer?
    answers.where(accepted: true).exists?
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
