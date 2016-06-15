require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'when guest' do
    let(:user) { nil }
    it { should be_able_to :read, :all }
    it { should_not be_able_to :read, User }

    it { should_not be_able_to :manage, :all }
  end

  context 'when user has authorized' do
    let(:user) { create :user }
    let(:user2) { create :user }

    let(:own_question) { create :question, user: user }
    let(:others_question) { create :question, user: user2 }

    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:question, user: user2) }
    it { should_not be_able_to :update, create(:answer, user: user2) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should be_able_to :destroy, create(:attachment, attachable: own_question) }
    it { should_not be_able_to :destroy, create(:question, user: user2) }
    it { should_not be_able_to :destroy, create(:answer, user: user2) }
    it { should_not be_able_to :destroy, create(:attachment, attachable: others_question) }

    it { should be_able_to :accept, create(:answer, question: own_question) }
    it { should_not be_able_to :accept, create(:answer, question: others_question) }

    it { should be_able_to :upvote, create(:question, user: user2) }
    it { should be_able_to :upvote, create(:answer, user: user2) }
    it { should_not be_able_to :upvote, create(:question, user: user) }
    it { should_not be_able_to :upvote, create(:answer, user: user) }

    it { should be_able_to :downvote, create(:question, user: user2) }
    it { should be_able_to :downvote, create(:answer, user: user2) }
    it { should_not be_able_to :downvote, create(:question, user: user) }
    it { should_not be_able_to :downvote, create(:answer, user: user) }

    it { should be_able_to :unvote, create(:question, user: user2, votes: create_list(:vote, 1, user: user)) }
    it { should be_able_to :unvote, create(:answer, user: user2, votes: create_list(:vote, 1, user: user)) }
    it { should_not be_able_to :unvote, create(:question, user: user) }
    it { should_not be_able_to :unvote, create(:answer, user: user) }
  end
end
