RSpec.describe Strategies::LeanKit::Reducers::ServiceLabelChange do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 actions'
  include_context 'LeanKit card actions reducer'

  describe '#tag_card_action' do
    let(:reducer_method) { :tag_card_action }
    let(:card_action)    { FactoryGirl.build(:card_action, description: { service_from: from, service_to: to }) }
    let(:start_label)    { Strategies::LeanKit::Reducers::ServiceLabelChange::SERVICE_LABEL_START }
    let(:ready_label)    { Strategies::LeanKit::Reducers::ServiceLabelChange::SERVICE_LABEL_READY }
    let(:other_label)    { 'Amaze' }

    describe 'match' do
      describe 'start -> ready' do
        let(:from) { start_label }
        let(:to)   { ready_label }

        it_behaves_like 'a match'
      end

      describe 'ready -> start' do
        let(:from) { ready_label }
        let(:to)   { start_label }

        it_behaves_like 'a match'
      end
    end

    describe 'non-match' do
      describe 'start -> other' do
        let(:from) { start_label }
        let(:to)   { other_label }

        it_behaves_like 'a non-match'
      end

      describe 'other -> start' do
        let(:from) { other_label }
        let(:to)   { start_label }

        it_behaves_like 'a non-match'
      end

      describe 'ready -> other' do
        let(:from) { ready_label }
        let(:to)   { other_label }

        it_behaves_like 'a non-match'
      end

      describe 'other -> ready' do
        let(:from) { other_label }
        let(:to)   { ready_label }

        it_behaves_like 'a non-match'
      end
    end
  end
end
