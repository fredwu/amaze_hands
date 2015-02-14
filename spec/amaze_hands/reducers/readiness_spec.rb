RSpec.describe Reducers::Readiness do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 actions'
  include_context 'LeanKit card actions reducer'

  describe '#tag_card_action' do
    let(:reducer_method) { :tag_card_action }
    let(:card_action)    { FactoryGirl.build(:card_action, description: { ready: ready }) }

    describe 'match' do
      let(:ready) { true }

      it_behaves_like 'a match'
    end

    describe 'non-match' do
      let(:ready) { false }

      it_behaves_like 'a non-match'
    end
  end
end
