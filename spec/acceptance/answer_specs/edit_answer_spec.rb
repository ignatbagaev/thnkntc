require 'rails_helper'

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
  
  scenario 'link to edit' do
    visit question_path(question)
    click_link "Edit answer"
    expect(current_path).to eq edit_answer_path(answer)
  end

  scenario 'with valid attributes' do
    visit edit_answer_path(answer)
    fill_in "Body", with: "Updated body of answer"
    click_button "Send answer"
    expect(current_path).to eq question_path(question)

  end

  scenario 'with invalid attributes' do
    visit edit_answer_path(answer)
    fill_in "Body", with: nil
    click_button "Send answer"
    expect(current_path).to eq answer_path(answer)
    expect(page).to have_content("error")
  end
end