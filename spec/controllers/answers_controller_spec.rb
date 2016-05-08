require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question)}

  describe 'POST #create' do
    login_user
    context 'with valid parameters' do
      it 'it associates answer with question and saves it to database' do
        expect { post :create, question_id: question.id,
                               answer: attributes_for(:answer), format: :js }
              .to change(question.answers, :count).by 1 
      end

      it 'it associates answer with user and saves it to database' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer), format: :js }
              .to change(@user.answers, :count).by 1 
      end

      it 'should redirect to question page' do
        post :create, question_id: question.id, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid parameters' do
      it 'should not create new answer' do
        expect { post :create, question_id: question.id, 
                               answer: { body: nil }, format: :js
                }.to_not change(Answer, :count)
      end
      it 'should re-render new template' do
        post :create, question_id: question.id, answer: { body: nil }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'GET #edit' do
    login_user
    before { @user.answers << answer }
    it 'assigns answer to @answer' do
      get :edit, id: answer
      expect(assigns(:answer)).to eq answer
    end

    it 'renders edit view' do
      get :edit, id: answer
      expect(response).to render_template :edit
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create :answer }
    context 'user is not logged in' do
      it 'does not update the answer' do
        patch :update, id: answer, answer: { body: "Edited body" }
        answer.reload
        expect(answer.body).to_not eq "Edited body"
      end
    end
    context 'user is logged in' do
      login_user
      it 'assigns requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end
      
      it "does not update update anybody's answer" do
        patch :update, id: answer, answer: { body: "Edited body" }
        answer.reload
        expect(answer.body).to_not eq "Edited body"
      end

      context 'user owns the answer' do
        it 'updates answer with valid attributes if user owns the answer' do
          @user.answers << answer
          patch :update, id: answer, answer: { body: "Edited body" }
          answer.reload
          expect(answer.body).to eq "Edited body"
        end

        it 'does not update answer with invalid attributes' do
          @user.answers << answer
          patch :update, id: answer, answer: { body: nil }
          answer.reload
          expect(answer.body).to_not eq nil
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    login_user
    let(:user) { create :user }
    context 'by owner' do
      before do
        question.answers << answer
        @user.answers << answer
      end
      it 'deletes answer' do 
        expect { delete :destroy, id: answer.id,
                                  question_id: question.id,
                                  format: :js
                }.to change(@user.answers, :count).by(-1) 
      end
    end

    context 'by someone' do
      it 'does not delete answer' do
        question.answers << answer
        user.answers << answer
        expect { delete :destroy, id: answer.id,
                                  question_id: question.id,
                                  format: :js
                }.to_not change(question.answers, :count)
      end
    end
  end

  describe 'PATCH #accept' do
    login_user

    it 'assigns requested answer to @answer' do
      post :accept, id: answer, format: :js
      expect(assigns(:answer)).to eq answer
    end
    it 'marks answer as accepted for own question' do
      @user.questions << question
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer.status).to eq "accepted"
    end

    let(:accepted_answer) { create(:accepted_answer)}
    it 'could accept another answer' do
      @user.questions << question
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer.status).to eq "accepted"
    end

    it 'changes previous accepted answer to common if user accepts another answer' do
      @user.questions << question
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      accepted_answer.reload
      expect(accepted_answer.status).to eq "common"
    end

    it 'could not mark as accepted an answer of another\'s question' do
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer.status).to eq "common"
    end
  end
end