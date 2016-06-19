require_relative '../acceptance_helper'

feature 'anybody could see list of questions', '
  In order to be able to find some question
  As user
  I want to have access to list of questions
' do
  scenario 'when there are no questions' do
    visit questions_path
    expect(page).to have_content 'No questions.'
  end

  context 'when there are questions' do
    given!(:questions) { create_list(:question, 5) }

    scenario 'could see list of questions' do
      visit questions_path
      questions.each do |question|
        expect(page).to have_selector(:link_or_button, question.title)
      end
    end
  end
end

feature 'User could visit the show page of question', "
  In order to see full body of a question
  As user
  I want to have access to question's show page
" do
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
