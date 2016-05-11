require_relative '../acceptance_helper'

feature 'edit own answer', %q{
  In order to get rid of my answer
  As user
  I want to be able to delete my own answer
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer) { create(:answer, user: user)}
  before { question.answers << answer }
  before(:each) { log_in user }
  
  scenario 'link to edit', js: true do
    visit question_path(question)
    click_link "Edit answer"
    expect(current_path).to eq question_path(question)
  end

  scenario 'with valid attributes', js: true do
    id = answer.id
    visit question_path(question)
    click_link "Edit answer"
    # save_and_open_page
    within("#edit-answer-#{id}") do
      fill_in "Body", with: "Updated body of answer"
      click_button "Save"
    end
    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Updated body of answer")
    
  end

  scenario 'with invalid attributes', js: true do
    id = answer.id
    visit question_path(question)
    click_link "Edit answer"
    within("#edit-answer-#{id}") do
      fill_in "Body", with: nil
      click_button "Save"
    end
    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Body can't be blank")
  end
end