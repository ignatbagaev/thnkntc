require 'rails_helper'

feature 'create answers', %q{
  In order to help with solving issues
  As user
  I want to be able to create answers
} do 
  
  given(:user) { create :user }
  given(:question) {create :question}

  scenario 'unless user logged in' do
    visit question_path(question)
    expect(page).to have_content("Sign in to do it")
  end

  scenario 'with valid attributes if user logged in' do
    log_in user
    visit question_path(question)
    fill_in "Body", with: "Some long text"
    click_on "Send"

    expect(page).to have_content("Thank you for reply!")
    expect(page).to have_content("Some long text")
    expect(current_path).to eq question_path(question)
  end

  scenario 'with invalid attributes' do
    log_in user
    visit question_path(question)
    fill_in "Body", with: nil
    click_on "Send"
    expect(current_path).to eq question_answers_path(question)
  end
end