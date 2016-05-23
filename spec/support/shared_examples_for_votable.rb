shared_examples 'votable' do


  describe '#vote!' do
    it { should have_many(:votes).dependent(:destroy) }

    let(:user) { create :user }
    subject(:votable) { create(described_class.to_s.underscore.to_sym) }


    context 'when there is no previous vote' do
      context 'when action upvote' do
        before { votable.vote!('upvote', user) }
        it 'creates positive vote' do
          expect(votable.votes.where(value: 1).count).to eq 1
        end
        it 'increases rating by 1' do
          expect(votable.rating).to eq 1
        end
      end
      context 'when action downvote' do
        before { votable.vote!('downvote', user) }
        it 'creates positive vote' do
          expect(votable.votes.where(value: -1).count).to eq 1
        end
        it 'increases rating by 1' do
          expect(votable.rating).to eq -1
        end
      end
      context 'when action unvote' do
        it 'does nothing' do
          expect(votable.vote!('unvote', user)).to be_falsey
        end
      end
    end

    context 'when there is previous vote' do
      before{ votable.vote!('upvote', user) }

      context 'when action upvote' do
        it 'does nothing' do
          expect(votable.vote!('upvote', user)).to be_falsey
        end
      end

      context 'when action downvote' do
        it 'does nothing' do
          expect(votable.vote!('downvote', user)).to be_falsey
        end
      end

      context 'when action unvote' do
        before { votable.vote!('unvote', user)}

        it 'deletes vote' do
          expect(votable.votes.find_by(user_id: user.id)).to be_falsey
        end
        it 'decreases rating by vote value' do
          expect(votable.rating).to eq 0
        end
      end
    end
  end
end
