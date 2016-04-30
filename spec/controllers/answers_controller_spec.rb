require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer)}

  describe 'POST #create' do
    login_user
    context 'with valid parameters' do
      it 'it associates answer with question and saves it to database' do
        expect { post :create, question_id: question.id,
                               answer: attributes_for(:answer) }
              .to change(question.answers, :count).by 1 
      end

      it 'it associates answer with user and saves it to database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
              .to change(@user.answers, :count).by 1 
      end

      it 'should redirect to question page' do
        post :create, question_id: question.id, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid parameters' do
      it 'should not create new answer' do
        expect { post :create, question_id: question.id, 
                               answer: { body: nil } 
                }.to_not change(Answer, :count)
      end
      it 'should re-render new template' do
        post :create, question_id: question.id, answer: { body: nil }

        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy'
    login_user
    let(:user) { create :user }
    context 'by owner' do
      before do
        question.answers << answer
        @user.answers << answer
      end
      it 'deletes answer' do 
        expect { delete :destroy, id: answer.id,
                                  question_id: question.id
                }.to change(@user.answers, :count).by(-1) 
      end
      it 'redirects back to question' do
        delete :destroy, id: answer.id, question_id: question.id
        expect(response).to redirect_to question
      end
    end

    context 'by someone' do
      it 'does not delete answer' do
        question.answers << answer
        user.answers << answer
        expect { delete :destroy, id: answer.id,
                                  question_id: question.id
                }.to_not change(question.answers, :count)
      end
      it 'redirects back to question' do
        delete :destroy, id: answer.id, question_id: question.id
        expect(response).to redirect_to question
      end
    end
end