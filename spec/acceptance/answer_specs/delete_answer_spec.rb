require 'rails_helper'

feature 'delete answer', %{
  In order to get rid of my answer
  As user
  I want to be able to delete my own answer
} do

  given(:user) { create :user }
  given(:user2) { create :user }
  given(:question) { create :question }
  given(:answer) { create :answer, question: question, user: user }
  
  scenario 'user could delete own answer' do
    user.questions << question
    user.answers << answer
    log_in(user)
    visit question_path(question)
    click_on 'Delete answer'
    expect(page).to_not have_content(answer.body)
  end

  scenario 'user could not delete someone\'s answer' do
    user2.questions << question
    user2.answers << answer
    log_in(user)
    visit question_path(question)
    expect(page).to_not have_selector(:link_or_button, 'Delete')
  end

end