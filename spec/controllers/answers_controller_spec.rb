require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe 'POST #create' do
    login_user
    context 'with valid parameters' do
      it 'it associates answer with question and saves it to database' do
        expect do
          post :create, question_id: question.id,
                        answer: attributes_for(:answer), format: :js
        end
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
        expect do
          post :create, question_id: question.id,
                        answer: { body: nil }, format: :js
        end.to_not change(Answer, :count)
      end
      it 'should re-render new template' do
        post :create, question_id: question.id, answer: { body: nil }, format: :js

        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    let(:answer) { create :answer }
    context 'user is not logged in' do
      it 'does not update the answer' do
        patch :update, id: answer, answer: { body: 'Edited body' }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'Edited body'
      end
    end
    context 'user is logged in' do
      login_user
      it 'assigns requested answer to @answer' do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it "does not update anybody's answer" do
        patch :update, id: answer, answer: { body: 'Edited body' }, format: :js
        answer.reload
        expect(answer.body).to_not eq 'Edited body'
      end

      context 'user owns the answer' do
        it 'updates answer with valid attributes if user owns the answer' do
          @user.answers << answer
          patch :update, id: answer, answer: { body: 'Edited body' }, format: :js
          answer.reload
          expect(answer.body).to eq 'Edited body'
        end

        it 'does not update answer with invalid attributes' do
          @user.answers << answer
          patch :update, id: answer, answer: { body: nil }, format: :js
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
        expect do
          delete :destroy, id: answer.id,
                           format: :js
        end.to change(@user.answers, :count).by(-1)
      end
    end

    context 'by someone' do
      it 'does not delete answer' do
        question.answers << answer
        user.answers << answer
        expect do
          delete :destroy, id: answer.id,
                           format: :js
        end.to_not change(question.answers, :count)
      end
    end
  end

  describe 'POST #accept' do
    login_user

    it 'assigns requested answer to @answer' do
      post :accept, id: answer, format: :js
      expect(assigns(:answer)).to eq answer
    end
    it 'marks answer as accepted for own question' do
      @user.questions << question
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer).to be_accepted
    end

    let(:accepted_answer) { create(:accepted_answer) }
    it 'could accept another answer' do
      @user.questions << question
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer).to be_accepted
    end

    it 'changes previous accepted answer to common if user accepts another answer' do
      @user.questions << question
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      accepted_answer.reload
      expect(accepted_answer).to_not be_accepted
    end

    it 'could not mark as accepted an answer of another\'s question' do
      question.answers << accepted_answer
      post :accept, id: answer, format: :js
      answer.reload
      expect(answer).to_not be_accepted
    end
  end

  describe 'POST #upvote' do
    context 'if user not logged in' do
      let(:answer) { create :answer }
      it 'do not upvotes answer' do
        post :upvote, id: answer.id, format: :json
        expect(answer.rating).to eq 'rating: 0'
      end
    end
    context 'if user logged in' do
      login_user
      let(:question) { create :question }
      it 'upvotes answer' do
        post :upvote, id: answer.id, format: :json
        expect(answer.rating).to eq 'rating: 1'
      end
    end
  end

  describe 'POST #downvote' do
    context 'if user not logged in' do
      let(:answer) { create :answer }
      it 'do not downvotes answer' do
        post :downvote, id: answer.id, format: :json
        expect(answer.rating).to eq 'rating: 0'
      end
    end
    context 'if user logged in' do
      login_user
      let(:question) { create :question }
      it 'downvotes answer' do
        post :downvote, id: answer.id, format: :json
        expect(answer.rating).to eq 'rating: -1'
      end
    end
  end

  describe 'DELETE #unvote' do
    login_user
    let(:answer) { create :answer }
    let(:vote) { create(:vote) }
    it 'unvotes answer' do
      answer.votes << vote
      @user.votes << vote
      delete :unvote, id: answer.id, format: :json
      expect(answer.votes.find_by(user_id: @user)).to eq nil
    end
  end
end
