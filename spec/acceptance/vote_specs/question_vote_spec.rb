require_relative '../acceptance_helper'

feature 'vote for question' do
  let(:user) { create :user }
  let(:user2) { create :user }
  let(:question) { create(:question, user: user2) }
  let(:vote) { create(:vote) }

  scenario 'guest could not vote' do
    visit question_path(question)
    expect(page).to_not have_link('Upvote')
  end

  scenario 'user could upvote for anothers question', js: true do
    log_in user
    visit question_path(question)
    click_link('Upvote')
    expect(page).to have_content('rating: 1')
  end

  scenario 'user could downvote for anothers question', js: true do
    log_in user
    visit question_path(question)
    click_link('Downvote')
    expect(page).to have_content('rating: -1')
  end

  scenario 'user could not vote for own question', js: true do
    log_in user
    user.questions << question
    visit question_path(question)
    expect(page).to_not have_link('Upvote')
    expect(page).to_not have_link('Downvote')
  end

  scenario 'user could not vote twice for question', js: true do
    log_in user
    user.votes << vote
    question.votes << vote
    visit question_path(question)
    expect(page).to_not have_link('Upvote')
    expect(page).to_not have_link('Downvote')
    expect(page).to have_link('Unvote')
  end

  scenario 'user could unvote question', js: true do
    log_in user
    user.votes << vote
    question.votes << vote
    visit question_path(question)
    click_link('Unvote')
    expect(page).to have_content('rating: 0')
  end
end
