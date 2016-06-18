require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }
  it { should have_many(:comments).dependent(:destroy) }
  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should respond_to :accept! }

  let(:question) { create :question }
  let(:answer) { create(:answer, question: question) }
  let(:accepted_answer) { create(:accepted_answer, question: question) }
  let(:answer2) { create :answer }
  let(:positive_votes) { create_list(:positive_vote, 2) }
  let(:negative_vote) { create :negative_vote }

  it_behaves_like 'votable'
  it_behaves_like 'attachable'

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

  describe 'notifications' do
    let(:question) { create :question }
    let(:subscriptions) { create_list(:subscription, 2, question: question)}

    let(:answer) { build :answer, question: question }
    it 'sends email to question owner and subscribers when answer is created' do
      # Answer#notify_question_owner
      expect(NotificationsMailer).to receive(:new_answer).with(answer, answer.question.user.email).and_call_original

      # Answer#notify_question_subscribers
      expect(NotifySubscribersJob).to receive(:perform_later).with(answer, question)

      answer.save!
    end
  end
end
