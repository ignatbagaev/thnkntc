require_relative '../acceptance_helper'

feature 'create subscription' do
  let(:user) { create :user }
  let(:own_question) { create(:question, user: user) }
  let(:question) { create :question }

  context 'guest user' do
    scenario 'could not subscribe on question' do
      visit question_path(question)
      expect(page).to_not have_button('Subscribe')
    end
  end

  context 'authenticated user' do
    before { log_in user }

    scenario 'could subscribe on question', js: true do
      visit question_path(question)
      click_button('Subscribe')
      expect(page).to have_link 'Cancel subscription'
    end
  end
end
