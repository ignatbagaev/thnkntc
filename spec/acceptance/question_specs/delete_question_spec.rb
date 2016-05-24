require_relative '../acceptance_helper'

feature 'delete own questions' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  scenario 'delete own question', js: true do
    user.questions << question
    log_in user
    visit question_path(question)
    click_link 'Delete question'
    sleep 1
    expect(current_path).to eq questions_path
    expect(page).to_not have_content question.title
  end

  scenario 'delete anothers question' do
    user2.questions << question
    log_in user
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end
