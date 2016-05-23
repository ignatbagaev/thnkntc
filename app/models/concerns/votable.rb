module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end


  def upvote!(user)
    transaction do
      votes.create(value: 1, user: user)
      update(rating: (rating + 1))
    end
  end

  def downvote!(user)
    transaction do
      votes.create(value: -1, user: user)
      update(rating: (rating + (-1)))
    end
  end

  def unvote!(user)
    transaction do
      vote = votes.find_by(user_id: user.id)
      return false unless vote
      value = vote.value
      vote.destroy && update(rating: (rating - value))
    end
  end
end
