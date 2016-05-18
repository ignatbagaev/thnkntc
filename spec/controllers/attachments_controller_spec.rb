require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer }
  let(:attachment) { create :attachment }

  describe 'DELETE #destroy' do

    context 'unless logged in' do
      before { question.attachments << attachment}
      it 'does not deletes attachment' do
        expect { delete :destroy, id: attachment.id, format: :js }.to_not change(Attachment, :count)
      end
    end

    login_user

    context 'own question\'s attachment' do
      before do
        @user.questions << question
        question.attachments << attachment
      end
      it 'deletes' do
        expect { delete :destroy, id: attachment.id, format: :js }.to change(question.attachments, :count).by(-1)
      end
    end

    context 'own answer\'s attachment' do
      before do
        @user.answers << answer
        answer.attachments << attachment
      end
      it 'deletes' do
        expect { delete :destroy, id: attachment.id, format: :js }.to change(answer.attachments, :count).by(-1)
      end
    end

    context 'another\'s question\'s attachment' do
      before do
        user.questions << question
        question.attachments << attachment
      end
      it 'does not delete' do
        expect { delete :destroy, id: attachment.id, format: :js }.to_not change(Attachment, :count)
      end
    end

    context 'another\'s answer\'s attachment' do
      before do
        user.answers << answer
        answer.attachments << attachment
      end
      it 'does not delete' do
        expect { delete :destroy, id: attachment.id, format: :js }.to_not change(Attachment, :count)
      end
    end

  end

end
