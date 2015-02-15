RSpec.describe Reducers::LaneMovement do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 actions'
  include_context 'Card actions service class'

  let(:service_class) { described_class.new(card_actions, lanes: Strategies::LeanKit::Lanes) }

  describe '#tag_created_in' do
    let(:method_name) { :tag_created_in }

    describe 'match' do
      let(:card_action) { FactoryGirl.build(:card_action, :created_in) }

      it_behaves_like 'a match'
    end

    describe 'non-match' do
      describe 'non-analysable created_in' do
        let(:card_action) { FactoryGirl.build(:card_action, description: { created_in: 'Triage: Triage' }) }

        it_behaves_like 'a non-match'
      end

      describe 'non-created_in' do
        let(:card_action) { FactoryGirl.build(:card_action) }

        it_behaves_like 'a non-match'
      end
    end
  end

  describe '#tag_moved' do
    let(:method_name) { :tag_moved }
    let(:card_action) { FactoryGirl.build(:card_action, description: { from: from, to: to }) }

    describe 'match' do
      describe 'initial to in-progress' do
        let(:from) { 'Doing: Capability' }
        let(:to)   { 'QA' }
      end

      describe 'between in-progress' do
        let(:from) { 'QA' }
        let(:to)   { 'BAT' }

        it_behaves_like 'a match'
      end

      describe 'in-progress to final' do
        let(:from) { 'BAT' }
        let(:to)   { 'Done' }

        it_behaves_like 'a match'
      end
    end

    describe 'non-match' do
      describe 'into initial' do
        let(:from) { 'Prioritised Backlog: Capability' }
        let(:to)   { 'Doing: Capability' }

        it_behaves_like 'a non-match'
      end

      describe 'out of initial' do
        let(:from) { 'Doing: Capability' }
        let(:to)   { 'Prioritised Backlog: Capability' }

        it_behaves_like 'a non-match'
      end

      describe 'out of final' do
        let(:from) { 'Done' }
        let(:to)   { 'Archive: Pricing' }

        it_behaves_like 'a non-match'
      end

      describe 'back into final' do
        let(:from) { 'Archive: Pricing' }
        let(:to)   { 'Done' }

        it_behaves_like 'a non-match'
      end
    end
  end
end
