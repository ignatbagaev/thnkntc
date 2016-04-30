require 'rails_helper'

feature 'create question', %q{
  In order to solve my issue
  As user
  I can create a question
} do

  given(:user) { create(:user) }

  scenario 'unless user logged in' do
    expect(page).to_not have_selector(:link_or_button, "New question")
  end

  scenario 'with valid attributes if user logged in' do 
    log_in user
    visit new_question_path
    fill_in "Title", with: 'My question'
    fill_in "Body",  with: 'Description of my issue'
    click_on 'Ask'
    expect(page).to have_content 'Question successfuly created'
    expect(page).to have_content 'My question'
    expect(page).to have_content 'Description of my issue'
    
  end

  scenario 'with invalid attributes if user logged in' do
    log_in user
    visit new_question_path
    fill_in "Title", with: nil
    fill_in "Body",  with: nil
    click_on 'Ask'

    expect(page).to have_content 'error'
  end
end