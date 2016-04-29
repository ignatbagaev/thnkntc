require 'rails_helper'

feature 'Authenticated user can delete only own questions and answers' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }


  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  def log_in
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_on "Log in"
  end

  scenario 'Delete own question' do
    user.questions << question

    log_in

    visit question_path(question)

    expect { click_link 'Delete question'}.to change(Question, :count).by(-1)
    expect(current_path).to eq questions_path
  end

  scenario 'Delete someone question' do
    user2.questions << question

    log_in

    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end

end