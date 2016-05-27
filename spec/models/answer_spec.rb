require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many :attachments }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should accept_nested_attributes_for :attachments }
  it { should respond_to :accept! }

  let(:question) { create :question }
  let(:answer) { create(:answer, question: question) }
  let(:accepted_answer) { create(:accepted_answer, question: question) }
  let(:answer2) { create :answer }
  let(:positive_votes) { create_list(:positive_vote, 2) }
  let(:negative_vote) { create :negative_vote }

  it_behaves_like 'votable'

  describe '.default_scope' do
    it 'shows the accepted answer at the top of the list' do
      expect(accepted_answer).to eq Answer.first
    end
  end

  describe '#accept!' do
    it 'accepts answer' do
      expect do
        answer.accept!
      end.to change { answer.accepted }.from(false).to(true)
    end

    it 'rejects previous accepted answer' do
      expect do
        answer.accept!
      end.to change { accepted_answer.reload.accepted }.from(true).to(false)
    end
  end
end
