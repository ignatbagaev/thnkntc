module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
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
