require 'rails_helper'

feature 'delete answer', %{
  In order to get rid of my questions
  As user
  I want to be able to delete my own quesions
} do

  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question }
  given(:answer) { create :answer, question: question, user: user }

  def log_in(user)
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end

  scenario 'user could delete own answer' do
    user.questions << question
    user.answers << answer
    log_in(user)
    visit question_path(question)
    expect { click_on 'Delete'}.to change(Answer, :count).by(-1)
  end

  scenario 'user could not delete someone\'s answer' do
    user2.questions << question
    user2.answers << answer
    log_in(user)
    visit question_path(question)
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

end