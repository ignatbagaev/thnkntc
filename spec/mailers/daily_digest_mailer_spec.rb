require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do

  describe '#daily_digest' do
    let(:users) { create_list(:user, 2) }
    let!(:questions) { create_list(:question, 2, created_at: Time.now.midnight - 1.hour) }
    let(:email) { described_class.daily_digest(users.first) }

    it 'sends emails to each user' do
      users.each do |user|
        expect { DailyDigestMailer.daily_digest(user).deliver_now  }.to change(ActionMailer::Base.deliveries, :count).by 1
      end
    end

    it 'sends email with question titles only' do      
      questions.each do |question|
        expect(email).to have_content question.title
        expect(email).to_not have_content question.body
      end
    end
  end
end
