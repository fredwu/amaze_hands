RSpec.describe Analysers::WaitDays do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject { CardLaneRepository.all }

    before do
      Analysers::WaitDays.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(1) }
  end

  describe 'private methods' do
    shared_context 'with 1 wait day' do
      let :next_movement_card_action do
        FactoryGirl.build(:card_action, :movement, date_time: (42.hours.since(card_action.date_time)))
      end

      before do
        allow(service_class).to receive(:next_movement_card_action).and_return(next_movement_card_action)
      end
    end

    shared_examples 'the next ready for pulling card action' do
      its(:date_time)   { is_expected.to eq(DateTime.parse('Tue, 10 Feb 2015 13:34:48 +1000')) }
      its(:description) { is_expected.to eq(from: 'QA', to: 'Deploying') }
    end

    let(:card_action) { card_actions.detect { |card_action| card_action.description[:ready] == true } }

    describe '#ready_for_pulling_card_actions' do
      subject { service_class.send(:ready_for_pulling_card_actions) }

      its(:length) { is_expected.to eq(1) }
    end

    describe '#record_wait_days' do
      let(:method_name) { :record_wait_days }

      its(:card_number) { is_expected.to eq(card_action.card_number) }
      its(:lane)        { is_expected.to eq('QA') }
      its(:wait_days)   { is_expected.to eq(0) }

      it 'records only once' do
        result
        expect(CardLaneRepository.all.count).to eq(1)
      end

      context 'with wait days' do
        include_context 'with 1 wait day'

        its(:wait_days) { is_expected.to eq(1) }
      end
    end

    describe '#calculate_wait_days' do
      let(:method_name) { :calculate_wait_days }

      it { is_expected.to eq(0) }

      context 'with wait days' do
        include_context 'with 1 wait day'

        it { is_expected.to eq(1) }
      end
    end

    describe '#next_movement_card_action' do
      let(:method_name) { :next_movement_card_action }

      it_behaves_like 'the next ready for pulling card action'
    end

    describe '#card_actions_in_future' do
      let(:method_name) { :card_actions_in_future }

      its(:length) { is_expected.to eq(2) }

      describe 'first future card action' do
        subject { result.first }

        it_behaves_like 'the next ready for pulling card action'
      end
    end
  end
end
