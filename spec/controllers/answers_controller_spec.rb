require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'it creates new answer in database and associates it with question' do
        expect { post :create, question_id: question.id, answer: attributes_for(:answer) }
              .to change(question.answers, :count).by 1 
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


end