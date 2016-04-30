require 'rails_helper'

feature 'Authenticated user can delete only own questions and answers' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }


  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'Delete own question' do
    user.questions << question
    log_in user
    visit question_path(question)
    click_link 'Delete question'
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'Delete someone question' do
    user2.questions << question
    log_in user
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end

end