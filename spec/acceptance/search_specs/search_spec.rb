require 'rails_helper'

feature 'searching' do
  given!(:question1) { create(:question, title: 'findme', body: 'body') }
  given!(:question2) { create(:question, title: 'title1', body: 'findme') }
  given!(:question3) { create(:question, title: 'title2', body: 'body') }
  before do 
    index
    visit root_path
  end

  scenario 'anybody can find any question' do
    fill_in 'query', with: 'find'
    click_button 'Search it'
    expect(current_path).to eq search_index_path
    expect(page).to have_content(question1.title)
    expect(page).to have_content(question2.title)
    expect(page).to_not have_content(question3.title)
  end
end
