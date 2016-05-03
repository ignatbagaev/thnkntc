require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of :password }
  it { should have_many(:answers) }
  it { should have_many(:questions) }
  it { should respond_to(:author_of?)}

  it 'returns true when object is associated with user' do
    user = FactoryGirl.create(:user)
    question = FactoryGirl.create(:question)
    user.questions << question
    expect(user.author_of?(question)).to eq true
  end
  
  it 'returns false when object is associated with user' do
    user = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:another_user)
    question = FactoryGirl.create(:question)
    user2.questions << question
    expect(user.author_of?(question)).to eq false
  end
end
