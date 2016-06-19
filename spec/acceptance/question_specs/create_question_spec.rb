require_relative '../acceptance_helper'

feature 'create question', '
  In order to solve my issue
  As user
  I can create a question
' do
  
  context 'when user is not authenticated' do
    scenario 'could not visit new_question_path' do
      visit root_path
      click_link 'New question'
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content 'You need to sign in'
    end
  end
  
  context 'when user is authenticated' do
    given(:user) { create(:user) }
    before { log_in user }

    scenario 'with valid attributes if user logged in' do
      visit new_question_path
      fill_in 'Title', with: 'My question'
      fill_in 'Body',  with: 'Description of my issue'
      click_on 'Ask'
      expect(page).to have_content 'My question'
      expect(page).to have_content 'Description of my issue'
      expect(page).to have_content 'subscribed'
      expect(page).to have_link 'cancel subscription'
    end

    scenario 'with invalid attributes if user logged in' do
      visit new_question_path
      fill_in 'Title', with: nil
      fill_in 'Body',  with: nil
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end
end
