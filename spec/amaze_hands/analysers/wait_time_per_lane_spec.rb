RSpec.describe Analysers::WaitTimePerLane do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject { CardLaneRepository.all }

    before do
      described_class.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(1) }
  end
end

RSpec.describe Analysers::WaitTimePerLane::TimeMaths do
  class DummyAnalyser
    def next_movement_card_action(card_action)
      CardAction.new(date_time: DateTime.parse('2015-01-02 04:00:00 PM'))
    end
  end

  describe '#formula' do
    subject { DummyAnalyser.new.instance_exec(&described_class.new.formula(card_action)) }

    context '0.5 day' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-02 01:00:00 PM')) }

      it { is_expected.to eq(0.1) }
    end

    context '1 day' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-02 11:00:00 AM')) }

      it { is_expected.to eq(0.2) }
    end

    context '1.5 days' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-01 01:00:00 PM')) }

      it { is_expected.to eq(1.1) }
    end

    context '2 days' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-01 11:00:00 AM')) }

      it { is_expected.to eq(1.2) }
    end
  end
end
