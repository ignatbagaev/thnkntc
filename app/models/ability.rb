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
    can :create, [Question, Answer, Comment, Attachment, Subscription]
    guest_abilities
    can [:me, :index], User
    owner_abilities
    voting_abilities
  end

  def voting_abilities
    can [:upvote, :downvote], [Answer, Question] do |votable|
      votable.votes.find_by(user_id: @user.id).nil? && !@user.author_of?(votable)
    end
    can :unvote, [Answer, Question] do |votable|
      votable.votes.find_by(user_id: @user.id) && !@user.author_of?(votable)
    end
  end

  def owner_abilities
    can [:update, :destroy], [Question, Answer, Subscription], user_id: @user.id
    can :destroy, Attachment, attachable: { user_id: @user.id }
    can :accept, Answer, question: { user_id: @user.id }
  end

  def guest_abilities
    can :read, :all
    cannot :read, User
  end
end
