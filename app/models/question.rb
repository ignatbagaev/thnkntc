class Question < ActiveRecord::Base
  include Attachable
  include Votable

  default_scope { order(created_at: :desc) }
  scope :to_daily_digest, -> { where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight) }
  
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  def has_accepted_answer?
    answers.where(accepted: true).exists?
  end
end
