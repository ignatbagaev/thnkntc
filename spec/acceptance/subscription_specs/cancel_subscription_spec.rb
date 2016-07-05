require_relative '../acceptance_helper'

feature 'cancel subscription' do
  let(:user) { create :user }
  let(:question) { create :question }

  context 'guest user' do
    scenario 'could not cancel subscription' do
      visit question_path(question)
      expect(page).to_not have_link('Cancel subscription')
    end
  end

  context 'authenticated user' do
    let(:subscription) { create(:subscription, question: question) }

    before do
      user.subscriptions << subscription
      log_in user
    end
    scenario 'could cancel subscription if user already subscribed', js: true do
      visit question_path(question)
      click_link('Cancel subscription')
      expect(page).to_not have_link('Cancel subscription')
      expect(page).to have_button('Subscribe')
    end
  end
end
