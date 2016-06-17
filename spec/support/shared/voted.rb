shared_examples 'voted' do
  describe 'POST #upvote' do
    let(:voted) { create_voted }
    context 'if user not logged in' do
      it 'do not upvotes answer' do
        post :upvote, id: voted.id, format: :json
        expect(voted.reload.rating).to eq 0
      end
    end
    context 'if user logged in' do
      login_user
      it 'upvotes answer' do
        post :upvote, id: voted.id, format: :json
        expect(voted.reload.rating).to eq 1
      end
    end
  end

  describe 'POST #downvote' do
    let(:voted) { create_voted }
    context 'if user not logged in' do
      it 'do not downvotes answer' do
        post :downvote, id: voted.id, format: :json
        expect(voted.reload.rating).to eq 0
      end
    end
    context 'if user logged in' do
      login_user
      it 'downvotes answer' do
        post :downvote, id: voted.id, format: :json
        expect(voted.reload.rating).to eq(-1)
      end
    end
  end

  describe 'DELETE #unvote' do
    login_user
    let(:voted) { create_voted }
    let(:vote) { create(:vote) }
    it 'unvotes answer' do
      voted.votes << vote
      @user.votes << vote
      delete :unvote, id: voted.id, format: :json
      expect(voted.votes.find_by(user_id: @user)).to eq nil
    end
  end
end
