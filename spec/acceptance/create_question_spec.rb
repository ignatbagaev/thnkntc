require 'rails_helper'

feature 'User could create question', %q{
  In order to solve my issue
  As user
  I can create a question
} do

  scenario 'user could create new question' do 
    visit new_question_path
    fill_in "Title", with: 'My question'
    fill_in "Body",  with: 'Description of my issue'
    click_on 'Ask'

    expect(page).to have_content 'Question successfuly created'
  end

  scenario 'user could not create question with invalid attributes' do
    visit new_question_path

    fill_in "Title", with: nil
    fill_in "Body",  with: nil
    click_on 'Ask'

    expect(page).to have_content 'error'
  end
end