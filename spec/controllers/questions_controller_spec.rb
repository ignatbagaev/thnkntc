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

  describe 'GET #new' do

    context 'when user is not logged in' do 
      it 'redirects to login page' do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'when user logged in' do
      login_user
      before(:each) { get :new }

      it 'assigns new question to @question' do
        expect(assigns(:question)).to be_a_new Question
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #create' do
    context 'when user is not logged in' do
      it 'does not saves the question' do
        expect { post :create, question: attributes_for(:question) }.to_not change(Question, :count)
      end
    end


    context 'with valid attributes when user logged in' do
      login_user
      it 'assciates new question with user and saves it to database' do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by 1
      end
      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end
    
    context 'with invalid attributes when user logged in' do
      login_user
      it 'does not save question to database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end
      it 'renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let(:question) { create :question }
    context 'user is not logged in' do
      it 'does not update the question' do
        patch :update, id: question, question: { title: "Edited title", body: "Edited body" }, format: :js
        question.reload
        expect(question.title).to_not eq "Edited title"
        expect(question.body).to_not eq "Edited body"
      end
    end
    context 'user is logged in' do
      login_user
      it 'assigns requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end
      
      it "does not update update anybody's question" do
        patch :update, id: question, question: { title: "Edited title", body: "Edited body" }, format: :js
        question.reload
        expect(question.title).to_not eq "Edited title"
        expect(question.body).to_not eq "Edited body"
      end

      context 'user owns the question' do
        it 'upates question with valid attributes if user owns the question' do
          @user.questions << question
          patch :update, id: question, question: { title: "Edited title", body: "Edited body" }, format: :js
          question.reload
          expect(question.title).to eq "Edited title"
          expect(question.body).to eq "Edited body"
        end

        it 'does not update question with invalid attributes' do
          @user.questions << question
          patch :update, id: question, question: { title: nil, body: nil }, format: :js
          question.reload
          expect(question.title).to_not eq nil
          expect(question.body).to_not eq nil
        end
      end
    end
  end
  
  describe 'DELETE #destroy' do
    context 'if user not logged in' do
      let(:user) { create :user }
      let(:question) { create :question }
      before { user.questions << question }
      it 'does not delete question' do
        expect { delete :destroy, id: question.id }.to_not change(Question, :count)
      end        
    end

    context 'if user logged in' do
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
