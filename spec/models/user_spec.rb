require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should have_many(:comments) }
  it { should respond_to(:author_of?) }

  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:user2) { create :user }
  describe '#author_of?' do
    it 'returns true when object is associated with user' do
      expect(user).to be_author_of question
    end

    it 'returns false when object is not associated with user' do
      user2.questions << question
      expect(user).to_not be_author_of question
    end
  end
end
