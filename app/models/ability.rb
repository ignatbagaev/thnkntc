class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user
    if @user
      user_abilities
    else
      guest_abilities
    end
  end

  private

  def user_abilities
    can :create, [Question, Answer, Comment, Attachment]
    guest_abilities
    owner_abilities
    voting_abilities
  end

  def voting_abilities
    [:upvote, :downvote, :unvote].each do |vote|
      can vote, [Answer, Question] do |votable|
        votable.user_id != @user.id
      end
    end
  end

  def owner_abilities
    can :update, [Question, Answer], user_id: @user.id
    can :destroy, [Question, Answer], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id}
    can :accept, Answer, question: { user_id: @user.id }
  end

  def guest_abilities
    can :read, :all
  end
end
