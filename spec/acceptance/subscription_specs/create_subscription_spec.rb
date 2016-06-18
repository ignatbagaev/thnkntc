require_relative '../acceptance_helper'

feature 'create subscription' do
  let(:user) { create :user }
  let(:own_question) { create(:question, user: user) }
  let(:question) { create :question }

  context 'guest user' do
    scenario 'could not subscribe on question' do
      visit question_path(question)
      expect(page).to_not have_button('subscribe')
    end
  end
  context 'authenticated user' do
    before { log_in user }

    scenario 'could not subscribe on own question' do
      visit question_path(own_question)
      expect(page).to_not have_button('subscribe')
    end

    scenario 'could subscribe on anothers question', js: true do
      visit question_path(question)
      click_button('subscribe')
      expect(page).to have_content 'subscribed'
    end
  end
end
