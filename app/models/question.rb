class Question < ActiveRecord::Base
  include Attachable
  include Votable

  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def has_accepted_answer?
    answers.where(accepted: true).exists?
  end
end
