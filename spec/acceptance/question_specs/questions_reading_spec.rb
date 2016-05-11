require_relative '../acceptance_helper'

feature 'User could see list of questions', %q{
  In order to be able to find some question
  As user
  I want to have access to listing of all questions
} do

  context 'when user is not authorized' do
    scenario 'page has not links to new question path' do
      visit questions_path
      expect(page).to_not have_selector(:link_or_button, 'Be first!')
      expect(page).to_not have_selector(:link_or_button, 'New question')
    end
  end

  given(:user) { create :user }

  context 'when user authorized and there are not questions' do
    scenario 'user could see link to create first question' do
      log_in user
      visit questions_path
      expect(page).to have_selector(:link_or_button, 'Be first!')
    end
  end

  context 'when user authorized and there are questions' do
    given!(:questions) { create_list(:question, 5) }
    scenario 'user could see listing of questions' do
      log_in user
      visit questions_path
      expect(page).to_not have_selector(:link_or_button, 'Be first!')
      expect(page).to have_selector(:link_or_button, 'New question')
      questions.each do |question|
        expect(page).to have_selector(:link_or_button, question.title)
      end
    end
  end
end

feature 'User could visit the show page of question', %q{
  In order to see full body of a question
  As user
  I want to have access to question's show page
} do

  given!(:question) { create :question }
  
  scenario 'users visits show page of certain question' do
    visit question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.title)
    expect(page).to have_selector(:link_or_button, 'Back')
  end

  given!(:answers) { create_list(:answer, 5, question: question) }
  
  scenario 'user could see the list of answers associated with question' do
    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end


