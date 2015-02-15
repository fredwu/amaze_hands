RSpec.describe Reducers::Readiness do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 actions'
  include_context 'Card actions service class'

  describe '#tag_card_action' do
    let(:method_name) { :tag_card_action }

    before do
      Reducers::LaneMovement.new(card_actions, lanes: Strategies::LeanKit::Lanes).tag
    end

    context 'before the first analysable movement action' do
      let(:card_action) { FactoryGirl.build(:card_action, date_time: DateTime.parse('01-01-2015'), description: { ready: ready }) }

      describe 'match' do
        let(:ready) { true }

        it_behaves_like 'a non-match'
      end

      describe 'non-match' do
        let(:ready) { false }

        it_behaves_like 'a non-match'
      end
    end

    context 'after the first analysable movement action' do
      let(:card_action) { FactoryGirl.build(:card_action, date_time: DateTime.parse('03-03-2015'), description: { ready: ready }) }

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
end
