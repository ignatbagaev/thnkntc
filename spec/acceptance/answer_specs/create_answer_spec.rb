require 'rails_helper'

feature 'User could create questions', %q{
  In order to help with solving issues
  As user
  I want to be able to create answers
} do 
  context 'create question with valid attributes' do
    given!(:question) {create :question}
    scenario 'user could create answer on question\'s page' do
      # pending("waitng for adding deep level test")
      visit question_path(question)
      
      fill_in "Body", with: "Some long text"
      click_on "Send"

      expect(page).to have_content("Thank you for reply!")
      expect(page).to have_content("Some long text")
      expect(current_path).to eq question_path(question)
    end
  end

  context 'create question with invalid attributes' do
    given!(:question) {create :question}
    scenario 'user could not create answer' do
      visit question_path(question)
      
      fill_in "Body", with: nil
      click_on "Send"

      expect(page).to have_content("error")
      expect(current_path).to eq question_answers_path(question)
    end
  end
end