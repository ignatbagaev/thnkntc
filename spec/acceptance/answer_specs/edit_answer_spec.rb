require_relative '../acceptance_helper'

feature 'edit own answer', %q{
  In order to get rid of my answer
  As user
  I want to be able to delete my own answer
} do

  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question }
  given(:answer) { create(:answer, user: user)}
  before { question.answers << answer }
  
  scenario 'link to edit is visible only for answer owner', js: true do
    log_in user2
    visit question_path(question)
    expect(page).to_not have_selector(:link, "Edit answer")
  end

  scenario 'with valid attributes', js: true do
    log_in user
    id = answer.id
    visit question_path(question)
    click_link "Edit answer"
    within("#edit-answer-#{id}") do
      fill_in "Body", with: "Updated body of answer"
      click_button "Save"
    end
    expect(current_path).to eq question_path(question)
    expect(page).to have_content("Updated body of answer")
    
  end

  scenario 'with invalid attributes', js: true do
    log_in user
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