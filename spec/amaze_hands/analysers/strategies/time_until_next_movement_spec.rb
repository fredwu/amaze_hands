RSpec.describe Analysers::Strategies::TimeUntilNextMovement do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'

  let(:service_class) do
    described_class.new(
      type:                    :wait_time,
      card_actions:            card_actions,
      apply_against_next_lane: true,
      time_maths:              Analysers::WaitTimePerLane::TimeMaths.new
    )
  end

  subject(:result) { service_class.send(method_name, card_action) }

  describe '#apply_on' do
    let(:ready_for_pulling_card_actions) { card_actions.to_a.select { |card_action| card_action.description[:ready] == true } }

    subject { CardLaneRepository.all }

    before do
      service_class.apply_on(ready_for_pulling_card_actions)
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

    describe '#record_time_until_next_movement' do
      subject(:result) do
        service_class.send(:record_time_until_next_movement, card_action)
      end

      its(:card_number) { is_expected.to eq(card_action.card_number) }
      its(:lane)        { is_expected.to eq('QA') }
      its(:wait_time)   { is_expected.to eq(1.0) }

      it 'records only once' do
        result
        expect(CardLaneRepository.all.count).to eq(1)
      end

      context 'with wait days' do
        include_context 'with 1 wait day'

        its(:wait_time) { is_expected.to eq(2.0) }
      end
    end

    describe '#next_movement_card_action' do
      let(:method_name) { :next_movement_card_action }

      it_behaves_like 'the next ready for pulling card action'
    end

    describe '#card_actions_in_future' do
      let(:method_name) { :card_actions_in_future }

      its(:length) { is_expected.to eq(3) }

      describe 'first future card action' do
        subject { result.first }

        it_behaves_like 'the next ready for pulling card action'
      end
    end
  end
end
