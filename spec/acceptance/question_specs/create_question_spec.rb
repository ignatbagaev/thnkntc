require_relative '../acceptance_helper'

feature 'create question', '
  In order to solve my issue
  As user
  I can create a question
' do
  given(:user) { create(:user) }
  before { log_in user }

  scenario 'with valid attributes if user logged in', js: true do
    visit new_question_path
    fill_in 'Title', with: 'My question'
    fill_in 'Body',  with: 'Description of my issue'
    click_on 'Ask'
    expect(page).to have_content 'My question'
    expect(page).to have_content 'Description of my issue'
  end

  scenario 'with invalid attributes if user logged in' do
    visit new_question_path
    fill_in 'Title', with: nil
    fill_in 'Body',  with: nil
    click_on 'Ask'
    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
  end
end
