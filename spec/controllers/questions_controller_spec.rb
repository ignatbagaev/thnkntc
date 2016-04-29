require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, id: question}
    
    it 'assigns the reqested question to @question' do
      expect(assigns(:question)).to eq question
    end
    
    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 5)}
    before { get :index }
    it 'assigns all questions to @questions' do
      expect(assigns(:questions)).to eq (questions)
    end
  end

  context 'when user is not logged in' do 
    describe 'GET #new' do
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    describe 'POST #create' do
      it 'does not saves the question' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end
    end
  end
  
  context 'when user logged in' do
    login_user
    describe 'GET #new' do
      before { get :new }

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new Question
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves new question to database' do
          expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by 1
        end
        it 'redirects to show view' do
          post :create, question: attributes_for(:question)
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context 'with invalid attributes' do 
        it 'does not save question to database' do
          expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
        end
        it 'renders new view' do
          post :create, question: attributes_for(:invalid_question)
          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #destroy' do
      login_user
      let(:user) { create :user }
      let(:question) { create :question }
      before { @user.questions << question}
      context 'own question' do
        it 'deletes question' do
          expect { delete :destroy, id: question.id }.to change(@user.questions, :count).by(-1)
        end
        it 'redirects to questions list' do
          delete :destroy, id: question.id
          expect(response).to redirect_to questions_path
        end
      end
      context 'someone\'s question' do
        before { user.questions << question }
        it 'does not delete question' do
          expect { delete :destroy, id: question.id }.to_not change(Question, :count)
        end          
        it 'redirects to questions list' do
          delete :destroy, id: question.id
          expect(response).to redirect_to question_path(question)
        end
      end
    end
  end
end
