shared_examples 'votable' do

  it { should have_many(:votes).dependent(:destroy) }
  
  let(:user) { create :user }
  subject(:votable) { create(described_class.to_s.underscore.to_sym) }

  describe '#upvote!' do
    context 'when there is no previous vote' do
      before { votable.upvote!(user) }

      it 'creates positive vote' do
        expect(votable.votes.where(value: 1).count).to eq 1
      end
      it 'increases rating by 1' do
        expect(votable.rating).to eq 1
      end
    
    end

    context 'when there is previous vote' do
      before { votable.upvote!(user) }
      it 'does nothing' do
        expect(votable.upvote!(user)).to be_falsey
      end
    end
  end

  describe '#downvote!' do
    context 'when there is no previous vote' do
      before { votable.downvote!(user) }

      it 'creates positive vote' do
        expect(votable.votes.where(value: -1).count).to eq 1
      end
      it 'increases rating by 1' do
        expect(votable.rating).to eq -1
      end
    
    end

    context 'when there is previous vote' do
      before { votable.downvote!(user) }
      it 'does nothing' do
        expect(votable.downvote!(user)).to be_falsey
      end
    end
  end

  describe '#unvote!' do
    context 'when there is no previous vote' do
      it 'does nothing' do
        expect(votable.unvote!(user)).to be_falsey
      end
    end

    context 'when there is previous vote' do
      before { votable.downvote!(user) }
      before { votable.unvote!(user) }
      it 'deletes vote' do
        # votable.unvote!(user)
        expect(votable.votes.find_by(user_id: user.id)).to be_falsey
      end
      it 'decreases rating by vote value' do
        expect(votable.rating).to eq 0
      end
    end
  end

end
