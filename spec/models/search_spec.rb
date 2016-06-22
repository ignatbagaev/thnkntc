require 'rails_helper'

RSpec.describe Search, type: :sphinx do
  describe '.find' do
    it 'returns requested questions' do
      question1 = create(:question, title: 'find', body: 'body')
      question2 = create(:question, title: 'title', body: 'find')
      question3 = create(:question, title: 'title', body: 'body')
      index

      expect(Search.find('find')).to match_array [question2, question1]
    end
  end
end
