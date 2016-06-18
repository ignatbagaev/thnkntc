require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should respond_to(:has_accepted_answer?) }
  it { should respond_to(:rating) }

  let(:question) { create :question }
  let(:answer) { create :answer }
  let(:accepted_answer) { create :accepted_answer }
  let(:positive_votes) { create_list(:positive_vote, 2) }
  let(:negative_vote) { create :negative_vote }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'

  describe '#has_accepted_answer?' do
    it 'returns true if question has accepted answer' do
      question.answers << accepted_answer
      expect(question.has_accepted_answer?).to eq true
    end

    it 'returns false if question has accepted answer' do
      question.answers << answer
      expect(question.has_accepted_answer?).to eq false
    end
  end
end
