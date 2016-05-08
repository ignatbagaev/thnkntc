require 'rails_helper'

feature 'best answer', %q{
  In order to tell others about answer solved my question
  As user
  I want to be able to flag answer as best
} do
  given(:user) { create :user }
  given(:user2) { create :user }
  given(:answers) { create_list(:answer, 2) }
  given(:question) { create(:question, user: user, answers: answers)}
  before(:each) { log_in user }

  scenario 'user could accept answer question' do
    visit question_path(question)
    answers.each do |answer|
      expect(page).to have_button("Accept")
    end
  end
  
  scenario 'question owner accepts answer', js: true do
    answer_id = question.answers.first.id
    visit question_path(question)
    page.find('#'+"accept-#{answer_id}").click 
    expect(page).to have_content("Accepted")
  end

  scenario 'question owner could not accept more than one answer', js: true do
    answer_id = question.answers.first.id
    visit question_path(question)
    page.find('#'+"accept-#{answer_id}").click 
    expect(page).to_not have_button("Accept")
  end

  scenario 'user could not accept answer of another\'s question' do
    user2.questions << question
    visit question_path(question)
    expect(page).to_not have_button("Accept")
  end

end