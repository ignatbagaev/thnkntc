require 'rails_helper'

feature 'create answers', %q{
  In order to help with solving issues
  As user
  I want to be able to create answers
} do 
  
  given(:question) {create :question}
  given(:user) { create :user }
  def visit_question_path
    visit question_path(question)
  end

  def log_in
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end

  scenario 'unless user logged in' do
    visit_question_path
    expect(page).to have_content("Sign in to do it")
  end

  scenario 'with valid attributes if user logged in' do
    log_in
    visit_question_path
    fill_in "Body", with: "Some long text"
    click_on "Send"

    expect(page).to have_content("Thank you for reply!")
    expect(page).to have_content("Some long text")
    expect(current_path).to eq question_path(question)
  end

  scenario 'with invalid attributes unless user logged in' do
    log_in
    visit_question_path
    fill_in "Body", with: nil
    click_on "Send"
    expect(page).to have_content("error")
    expect(current_path).to eq question_answers_path(question)
  end
end