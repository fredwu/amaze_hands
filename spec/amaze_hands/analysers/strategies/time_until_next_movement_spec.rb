RSpec.describe Analysers::Strategies::TimeUntilNextMovement do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'

  let(:service_class) do
    described_class.new(
      type:         :wait_time,
      card_actions: card_actions,
      time_maths:   Analysers::WaitTimePerLane::TimeMaths.new
    )
  end

  subject(:result) { service_class.send(method_name, card_action) }

  describe '#apply_on' do
    let(:ready_for_pulling_card_actions) { card_actions.to_a.select { |card_action| card_action.description[:ready] == true } }

    subject { CardLaneRepository.all }

    before do
      service_class.apply_on(ready_for_pulling_card_actions)
    end

    its(:count) { is_expected.to eq(2) }
  end

  describe 'private methods' do
    shared_examples 'the next ready for pulling card action' do
      its(:date_time)   { is_expected.to eq(DateTime.parse('Mon, 09 Feb 2015 14:41:28 +1000')) }
      its(:description) { is_expected.to eq(from: 'Doing: Capability', to: 'QA') }
    end

    let(:card_action) { card_actions.detect { |card_action| card_action.description[:ready] == true } }

    describe '#record_time_until_next_movement' do
      subject(:result) do
        service_class.send(:record_time_until_next_movement, card_action)
      end

      its(:card_number) { is_expected.to eq(card_action.card_number) }
      its(:lane)        { is_expected.to eq('Doing: Capability') }
      its(:wait_time)   { is_expected.to eq(0.0) }

      it 'records only once' do
        result
        expect(CardLaneRepository.all.count).to eq(1)
      end

      context 'with wait days' do
        shared_examples 'wait days analysis' do
          let(:next_non_analysable_movement_card_action) { FactoryGirl.build(:card_action, :movement, date_time: (22.hours.since(card_action.date_time)), description: { from: 'Prioritised Backlog: Capability', to: 'Doing: Capability' }) }
          let(:next_analysable_movement_card_action)     { FactoryGirl.build(:card_action, :movement, date_time: (42.hours.since(card_action.date_time)), description: { from: 'Doing: Capability', to: 'QA' }) }

          context 'without non-analysable actions' do
            before do
              allow(service_class).to receive(:card_actions_in_future).and_return([next_analysable_movement_card_action])
            end

            its(:wait_time) { is_expected.to eq(2.0) }
          end

          context 'with non-analysable actions' do
            before do
              allow(service_class).to receive(:card_actions_in_future).and_return([next_non_analysable_movement_card_action, next_analysable_movement_card_action])
            end

            its(:wait_time) { is_expected.to eq(wait_days) }
          end
        end

        describe 'from initial into movement' do
          let(:wait_days) { 1.0 }

          it_behaves_like 'wait days analysis'
        end

        describe 'from movement to movement' do
          let(:card_action) { card_actions.detect { |card_action| card_action.description[:to] == 'Doing: Capability' } }
          let(:wait_days)   { 2.0 }

          it_behaves_like 'wait days analysis'
        end
      end
    end

    describe '#next_movement_card_action' do
      let(:method_name) { :next_movement_card_action }

      it_behaves_like 'the next ready for pulling card action'
    end

    describe '#card_actions_in_future' do
      let(:method_name) { :card_actions_in_future }

      its(:length) { is_expected.to eq(5) }

      describe 'first future card action' do
        subject { result.first }

        it_behaves_like 'the next ready for pulling card action'
      end
    end
  end
end
