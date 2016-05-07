require 'rails_helper'

feature 'edit own question', %q{
  In orderto fix my question
  As user
  I want to be able to edit my questions
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  before(:each) { log_in user }
  
  scenario 'link to edit' do
    visit question_path(question)
    click_link "Edit"
    expect(current_path).to eq edit_question_path(question)
  end

  scenario 'with valid attributes' do
    visit edit_question_path(question)
    fill_in "Title", with: "Edited title"
    fill_in "Body", with: "Edited body"
    click_button "Ask"
    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Edited title")
    expect(page).to have_content("Edited body")
  end

  scenario 'with invalid attributes' do
    visit edit_question_path(question)
    fill_in "Title", with: nil
    fill_in "Body", with: nil
    click_button "Ask"
    expect(current_path).to eq edit_question_path(question)
    expect(page).to have_content 'error'
  end
end