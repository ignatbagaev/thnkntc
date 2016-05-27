require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create :question}

  describe 'POST #create' do
    login_user
    context 'when parameters are valid' do
      it 'associates comment with current user' do
        expect { post :create, comment: attributes_for(:comment), question_id: question.id, format: :js }
          .to change(@user.comments, :count).by 1
      end
      it 'associates comment with votable' do
        expect { post :create, comment: attributes_for(:comment), question_id: question.id, format: :js }
          .to change(question.comments, :count).by 1
      end
    end
    context 'when parameters are invalid' do
      it 'not creates comment' do
        expect { post :create, comment: attributes_for(:invalid_comment), question_id: question.id, format: :js }
          .to_not change(Comment, :count)
      end
    end
  end
end
