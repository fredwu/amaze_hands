RSpec.describe Analysers::CycleTimePerLane do
  include_context 'LeanKit P-217'
  include_context 'LeanKit P-217 analysable actions'
  include_context 'Card actions service class'

  describe '#analyse' do
    subject { CardLaneRepository.all }

    before do
      described_class.new(card_actions).analyse
    end

    its(:count) { is_expected.to eq(4) }
  end
end

RSpec.describe Analysers::CycleTimePerLane::TimeMaths do
  let(:next_card_action) { CardAction.new(date_time: DateTime.parse('2015-01-02 04:00:00 PM')) }

  describe '#formula' do
    subject { described_class.new.formula(card_action, next_card_action) }

    context '0.5 day' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-02 01:00:00 PM')) }

      it { is_expected.to eq(0.5) }
    end

    context '1 day' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-02 11:00:00 AM')) }

      it { is_expected.to eq(1.0) }
    end

    context '1.5 days' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-01 01:00:00 PM')) }

      it { is_expected.to eq(1.5) }
    end

    context '2 days' do
      let(:card_action) { CardAction.new(date_time: DateTime.parse('2015-01-01 11:00:00 AM')) }

      it { is_expected.to eq(2.0) }
    end
  end
end
