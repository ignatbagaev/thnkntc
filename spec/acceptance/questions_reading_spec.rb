require 'rails_helper'

feature 'User could see listing of questions', %q{
  In order to be able to find some question
  As user
  I want to have access to listing of all questions
} do

  context 'when there are not questions' do
    scenario 'user could see link to create first question' do
      visit questions_path

      expect(page).to have_selector(:link_or_button, 'Be first!')
      expect(page).to_not have_selector(:link_or_button, 'New question')
    end
  end

  context 'when there are questions' do
    given!(:questions) { create_list(:question, 5) }
    
    scenario 'user could see listing of questions' do
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
end


