require_relative '../acceptance_helper'

feature 'add attachment to question' do
  
  given(:user) { create :user }

  scenario 'add attachment to question while create question' do
    log_in user
    visit new_question_path
    fill_in 'Title', with: "Question title"
    fill_in 'Body', with: "Question body"
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_button 'Ask'
    expect(page).to have_link("rails_helper.rb")
  end
end